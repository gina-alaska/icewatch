class UploadedFile < ActiveRecord::Base
  belongs_to :cruise

  attachment :file

  def copy_to_photo
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
    photos = []
    tempdir = Dir.mktmpdir
    Dir.chdir(tempdir) do
      Zip::File.open(file.to_io) do |zip_file|
        zip_file.each do |entry|
          next unless image_file_extension?(entry.name)
          entry.extract(entry.name)

          photo = cruise.photos.build
          File.open(entry.name) do |f|
            photo.file = f
          end

          photos << photo if photo.save
        end
      end
    end
    photos
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

  def image_file_extension?(entry)
    %w{.jpg .jpeg .png .gif}.include? File.extname(entry.downcase)
  end
end
