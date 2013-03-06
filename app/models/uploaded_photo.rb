class UploadedPhoto
  include Mongoid::Document
  
  field :file_uid
  field :cruise_id
  field :file_name
  file_accessor :file
end