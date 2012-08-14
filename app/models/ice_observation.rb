class IceObservation
  include Mongoid::Document
  include AssistShared::Validations::IceObservation

  embedded_in :observation 
  
  embeds_one :melt_pond
  embeds_one :topography
  
  accepts_nested_attributes_for :melt_pond,:topography
  
  field :partial_concentration, type: Integer
  field :thickness, type: Integer
  field :snow_thickness, type: Integer
  field :floe_size_lookup_code, type: Integer
  field :snow_lookup_code, type: Integer
  field :ice_lookup_code, type: Integer
  field :biota_lookup_code, type: Integer
  field :sediment_lookup_code, type: Integer
  field :obs_type, type: String
end