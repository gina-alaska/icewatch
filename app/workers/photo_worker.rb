class PhotoWorker
  include Sidekiq::Worker

  def perform uploaded_photo_id
    photo = UploadedPhoto.where(id: uploaded_photo_id).first
    
    if photo.file.mime_type == "application/zip"
      Zip::ZipFile.open(photo.file.path) do |zip|
        zip.each do |file|
          u = UploadedPhoto.new file: zip.read(file), cruise_id: photo.cruise_id
          if u.save
            PhotoWorker.perform_async(u.id)
          end
        end
      end
      photo.destroy
    else
      save! photo
    end
  end
  
  def save! uploaded_photo
    md5 = Digest::MD5.hexdigest(File.read(uploaded_photo.file.path))
    
    #Try to find the photo by md5sum first
    photo = Photo.where(checksum_id: md5).first || Photo.new(checksum_id: md5)

    #If that fails, try to match the filename to an observation
    if photo.new_record? and !uploaded_photo.taken_at.nil?
      obs = Observation.where(obs_datetime: uploaded_photo.taken_at)
      photo.observation = obs unless obs.nil?
    end
  
    puts uploaded_photo.file_name
  
    photo.cruise_id = uploaded_photo.cruise_id
    photo.photo = File.new uploaded_photo.file.path
    photo.photo_name = uploaded_photo.file_name
    puts photo.photo_name
    if photo.save!
      uploaded_photo.destroy
    end
  end
end