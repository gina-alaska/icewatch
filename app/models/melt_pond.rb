class MeltPond < ActiveRecord::Base
  belongs_to :ice_observation
  belongs_to :max_depth_lookup
  belongs_to :surface_lookup
  belongs_to :pattern_lookup
  belongs_to :bottom_type_lookup

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

  %w(bottom_type max_depth pattern surface).each do |lookup|
    define_method "#{lookup}_lookup_code" do      # define_method "surface_lookup_code" do
      send("#{lookup}_lookup").try(&:code)    #   self.send("surface_lookup_code").try(&:code)
    end                                           # end
  end
end
