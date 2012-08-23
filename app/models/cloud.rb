class Cloud 
  include Mongoid::Document
  include AssistShared::Validations::Cloud
  include AssistShared::Validations
  include AssistShared::CSV::Cloud
  field :cover, type: Numeric
  field :height, type: Numeric
  field :cloud_type, type: String
  
  embedded_in :eteorology

  belongs_to :cloud_lookup
  
end