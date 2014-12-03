class Ice < ActiveRecord::Base
  belongs_to :observation
  belongs_to :thin_ice_lookup, class_name: 'IceLookup'
  belongs_to :thick_ice_lookup, class_name: 'IceLookup'
  belongs_to :open_water_lookup
end
