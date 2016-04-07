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

        zip_file.glob("*.json").each do |json_file|
          cruise.observations_from_export(Json.parse(File.read(json_file)))
        end

        image_file_extensions.each do |ext|
          zip_file.glob("*#{ext}") do |image_file|
            photo = cruise.photos.build
            File.open(entry.name) do |f|
              photo.file = f
            end

            photos << photo if photo.save
          end
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

  def image_file_extensions
    %w{.jpg .jpeg .png .gif}
  end

  def image_file_extension?(entry)
    image_file_extensions.include? File.extname(entry.downcase)
  end
end
