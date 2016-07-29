class UploadedFile < ActiveRecord::Base
  GLOB_OPTIONS = ::File::FNM_PATHNAME | ::File::FNM_DOTMATCH | ::File::FNM_CASEFOLD

  require 'net/ftp'
  belongs_to :cruise

  attachment :file

  def fetch!
    return if !file_id.nil?
    return if hosted_file_url.nil?

    fetch_ftp if ftp?
    fetch_http if http?

    save
  end

  def fetch_ftp
    dir = Dir.mktmpdir
    uri = URI.parse(hosted_file_url)
    host = uri.host
    path = File.dirname(uri.path)
    filename = File.basename(uri.path)
    Dir.chdir(dir) do
      Net::FTP.open(host) do |ftp|
        ftp.login
        ftp.chdir(path)
        ftp.getbinaryfile(filename, filename, 1024)
      end

      File.open(filename) do |f|
        self.file = f
      end
    end

  ensure
    FileUtils.safe_unlink(dir)
  end

  def fetch_http
    self.remote_file_url = hosted_file_url
  end

  def import!
    case file_content_type
    when 'application/zip'
      handle_zip
    when 'image/jpeg', 'image/png', 'image/gif'
      handle_image
    end
  end

  private
  def handle_image
    photo = cruise.photos.build(metadata)
    photo.file_id = file_id
    photo.save

    self.file_id = nil
    photo
  end

  def handle_zip
    tempdir = Dir.mktmpdir
    Dir.chdir(tempdir) do
      Zip::File.open(file.to_io) do |zip_file|
        zip_file.glob("**/*.json", GLOB_OPTIONS).each do |entry|
          filename = File.basename(entry.name)
          entry.extract(filename)

          cruise.observations_from_export(JSON.parse(File.read(filename)))

          FileUtils.remove_entry_secure(filename)
        end

        image_file_extensions.each do |ext|
          zip_file.glob("**/*#{ext}", GLOB_OPTIONS) do |entry|
            filename = File.basename(entry.name)
            entry.extract(filename)
            checksum = Digest::MD5.hexdigest(File.read(filename))

            # A photo can be uploaded multiple times.
            # This is not a good thing, but we have to handle this scenario.
            photos = cruise.photos.where(checksum: checksum, file_filename: filename)
            photos = [cruise.photos.build(checksum: checksum)] if photos.empty?

            photos.each do |photo|
              next if photo.file_id.present?
              File.open(filename) do |f|
                photo.file = f
              end
              photo.save
            end
            FileUtils.remove_entry_secure(filename)
          end
        end
      end
    end
  ensure
    FileUtils.remove_entry_secure(tempdir)
  end

  def metadata
    {
      file_filename: file_filename,
      file_content_type: file_content_type,
      file_size: file_size
    }
  end

  def image_file_extensions
    %w{.jpg .jpeg .png .gif}
  end

  def image_file_extension?(entry)
    image_file_extensions.include? File.extname(entry.downcase)
  end

  def http?
    self.hosted_file_url =~ /^http(s):\/\//
  end

  def ftp?
    self.hosted_file_url =~ /^ftp:\/\//
  end
end
