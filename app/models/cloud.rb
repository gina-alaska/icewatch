class Cloud 
  include Mongoid::Document
  include AssistShared::Validations::Cloud
  include AssistShared::Validations
  include AssistShared::CSV::Cloud
  field :cover, type: Numeric
  field :height, type: Numeric
  field :cloud_lookup_code, type: String
  field :cloud_type, type: String
  
  embedded_in :eteorology
  
end