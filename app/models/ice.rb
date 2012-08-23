class Ice
  include Mongoid::Document
  include AssistShared::Validations::Ice
  include AssistShared::CSV::Ice
  
  field :total_concentration, type: Numeric
  
  embedded_in :observation
  
  belongs_to :thin_ice_lookup, class_name: 'IceLookup'
  belongs_to :thick_ice_lookup, class_name: 'IceLookup'
  belongs_to :open_water_lookup

end
