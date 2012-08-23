class IceObservation
  include Mongoid::Document
  include AssistShared::Validations::IceObservation
  include AssistShared::CSV::IceObservation
  embedded_in :observation 
  
  embeds_one :melt_pond
  embeds_one :topography
  
  accepts_nested_attributes_for :melt_pond,:topography
  
  field :partial_concentration, type: Integer
  field :thickness, type: Integer
  field :snow_thickness, type: Integer
  field :obs_type, type: String

  belongs_to :floe_size_lookup
  belongs_to :snow_lookup
  belongs_to :ice_lookup
  belongs_to :biota_lookup
  belongs_to :sediment_lookup
end