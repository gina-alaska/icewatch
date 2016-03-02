class UploadedPhotoset < ActiveRecord::Base
  belongs_to :cruise

  attachment :file

end
