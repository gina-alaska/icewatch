class ImportPhotosetJob < ActiveJob::Base
  queue_as :default

  def perform(uploaded_photoset)
    uploaded_photoset.copy_to_photo
    # uploaded_photoset.destroy
  end

end
