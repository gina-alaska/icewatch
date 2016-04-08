class UploadedFile < ActiveRecord::Base
  belongs_to :cruise

  attachment :file

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
        zip_file.glob("*.json").each do |entry|
          entry.extract(entry.name)
          cruise.observations_from_export(JSON.parse(File.read(entry.name)))
        end

        image_file_extensions.each do |ext|
          zip_file.glob("**/*#{ext}") do |entry|
            filename = File.basename(entry.name)
            entry.extract(filename)
            checksum = Digest::MD5.hexdigest(File.read(filename))

            # A photo can be uploaded multiple times.
            # This is not a good thing, but we have to handle this scenario.
            photos = cruise.photos.where(checksum: checksum, file_filename: filename)
            photos ||= [cruise.photos.build(checksum: checksum)]

            photos.each do |photo|
              next if photo.file_id.present?
              File.open(filename) do |f|
                photo.file = f
              end
              photo.save
            end
            FileUtils.safe_unlink(filename)
          end
        end
      end
    end
  ensure
    FileUtils.safe_unlink(tempdir)
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
end
