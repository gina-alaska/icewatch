class Ice < ActiveRecord::Base
  include Lookupable

  CONCENTRATION_VALUES = (0..10).to_a
  belongs_to :observation

  lookup :thin_ice_lookup, class_name: 'IceLookup'
  lookup :thick_ice_lookup, class_name: 'IceLookup'
  lookup :open_water_lookup

  validates_presence_of :total_concentration
  validates :total_concentration, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }

  validates_with Validations::LookupCodeValidator,
                 fields: {
                   thin_ice_lookup_id: 'ice_lookup',
                   thick_ice_lookup_id: 'ice_lookup',
                   open_water_lookup_id: 'open_water_lookup'
                 },
                 allow_blank: true

  def as_csv
    [
      total_concentration,
      open_water_lookup.try(:code),
      thin_ice_lookup.try(:code),
      thick_ice_lookup.try(:code)
    ]
  end
end
