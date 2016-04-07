class MeltPond < ActiveRecord::Base
  include Lookupable
  belongs_to :ice_observation

  lookup :max_depth_lookup
  lookup :surface_lookup
  lookup :pattern_lookup
  lookup :bottom_type_lookup

  with_options allow_blank: true do |record|
    record.validates :surface_coverage, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
    record.validates :freeboard, numericality: { greater_than_or_equal_to: 0 }

    record.validates_with Validations::LookupCodeValidator, fields: {
      max_depth_lookup: 'max_depth_lookup',
      surface_lookup: 'surface_lookup',
      pattern_lookup: 'pattern_lookup'
    }

    def as_csv
      [
        surface_coverage,
        max_depth_lookup.try(:code),
        pattern_lookup.try(:code),
        surface_lookup.try(:code),
        freeboard,
        bottom_type_lookup.try(:code),
        dried_ice,
        rotten_ice
      ]
    end
  end
end
