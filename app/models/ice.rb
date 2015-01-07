class Ice < ActiveRecord::Base
  CONCENTRATION_VALUES=(0..10).to_a
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

  def as_csv
    [
      total_concentration,
      open_water_lookup.try(:code),
      thin_ice_lookup.try(:code),
      thick_ice_lookup.try(:code)
    ]
  end

  %w{open_water thin_ice thick_ice}.each do |lookup|
    define_method "#{lookup}_lookup_code" do      # define_method "open_water_lookup_code" do
      self.send("#{lookup}_lookup").try(&:code)    #   self.send("open_water_lookup_code").try(&:code)
    end                                           # end
  end
end
