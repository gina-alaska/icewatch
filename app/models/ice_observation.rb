class IceObservation
  include Mongoid::Document
  
  embedded_in :observation 
  
  embeds_one :melt_pond
  embeds_one :topography
  
  accepts_nested_attributes_for :melt_pond,:topography
  
end