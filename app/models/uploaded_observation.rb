class UploadedObservation
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :cruise
  
  field :import_errors, type: Array, default: []
  field :observations_uid
  file_accessor :observations
end
