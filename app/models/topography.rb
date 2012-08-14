class Topography
  include Mongoid::Document
  include AssistShared::Validations::Topography

  embedded_in :ice_observation

  field :old, type:Boolean
  field :snow_covered, type: Boolean
  field :concentration, type:Integer
  field :ridge_height, type:Numeric
end