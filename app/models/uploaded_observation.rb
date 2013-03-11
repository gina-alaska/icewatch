class UploadedObservation
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :cruise
  belongs_to :user
  
  field :import_errors, type: Array, default: []
  field :observations_uid
  file_accessor :observations
end
