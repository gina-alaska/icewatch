class UploadedObservation
  include Mongoid::Document

  belongs_to :cruise
  
  field :errors, type: Array
  field :observations_uid
  file_accessor :observations
end
