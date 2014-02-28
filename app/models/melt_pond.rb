class MeltPond
  include Mongoid::Document
  include AssistShared::Validations::MeltPond
  include AssistShared::CSV::MeltPond
  
  embedded_in :ice_observation
  
  field :surface_coverage, type: Integer
  field :freeboard, type: Integer

  belongs_to :max_depth_lookup
  belongs_to :surface_lookup
  belongs_to :pattern_lookup
  belongs_to :bottom_type_lookup
  
end