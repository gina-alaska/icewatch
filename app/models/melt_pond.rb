class MeltPond
  include Mongoid::Document
  include AssistShared::Validations::MeltPond
  include AssistShared::CSV::MeltPond
  
  embedded_in :ice_observation
  
  field :surface_coverage, type: Integer
  field :freeboard, type: Integer
  field :max_depth_lookup_code, type: Integer
  field :surface_lookup_code, type: Integer
  field :pattern_lookup_code, type: Integer

end