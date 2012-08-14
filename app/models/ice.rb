class Ice
  include Mongoid::Document
  include AssistShared::Validations::Ice

  field :total_concentration, type: Numeric
  field :thin_ice_lookup_code, type: Integer
  field :thick_ice_lookup_code, type: Integer
  field :open_water_lookup_code, type: Integer

  embedded_in :observation
  
  
end
