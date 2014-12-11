class MeltPond < ActiveRecord::Base
  belongs_to :ice_observation
  belongs_to :max_depth_lookup
  belongs_to :surface_lookup
  belongs_to :pattern_lookup
  belongs_to :bottom_type_lookup

  with_options allow_blank: true do |record|
    record.validates :surface_coverage, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10}
    record.validates :freeboard, numericality: {greater_than_or_equal_to: 0}

    record.validates_with Validations::LookupCodeValidator, fields: {
      max_depth_lookup: 'max_depth_lookup',
      surface_lookup: 'surface_lookup',
      pattern_lookup: 'pattern_lookup'
    }
  end
end
