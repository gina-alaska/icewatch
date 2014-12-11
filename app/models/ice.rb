class Ice < ActiveRecord::Base
  belongs_to :observation
  belongs_to :thin_ice_lookup, class_name: 'IceLookup'
  belongs_to :thick_ice_lookup, class_name: 'IceLookup'
  belongs_to :open_water_lookup

  validates_presence_of :total_concentration
  validates :total_concentration, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10}

  validates_with Validations::LookupCodeValidator,
    fields: {
      thin_ice_lookup_id: "ice_lookup",
      thick_ice_lookup_id: "ice_lookup",
      open_water_lookup_id: "open_water_lookup"
    },
    allow_blank: true
end
