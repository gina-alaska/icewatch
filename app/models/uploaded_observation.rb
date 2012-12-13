class UploadedObservation
  include Mongoid::Document
  
  field :observations_uid
  field :cruise_id
  
  file_accessor :observations
end
