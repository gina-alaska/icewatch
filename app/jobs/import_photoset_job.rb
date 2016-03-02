class ImportPhotosetJob < ActiveJob::Base
  queue_as :default

  def perform(uploaded_photoset)
    file = uploaded_photoset.download

    assign_or_create(file, uploaded_photoset.cruise)
  end

  def assign_or_create(file, photoable=nil)
    checksum = Digest::MD5.hexdigest(File.read(file))

    photo = Photo.where(checksum: checksum, name: File.basename(file))
    photo = photo.where(photoable: photoable) unless photoable.nil?
    photo = photo.first_or_initialize

    photo.tempfile = file
    photo.save
  end

end
