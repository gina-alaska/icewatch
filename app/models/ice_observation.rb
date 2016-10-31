class IceObservation < ActiveRecord::Base
  include Lookupable
  include Importable::IceObservation
  belongs_to :observation

  lookup :algae_lookup
  lookup :algae_density_lookup
  lookup :algae_location_lookup
  lookup :floe_size_lookup
  lookup :ice_lookup
  lookup :sediment_lookup
  lookup :snow_lookup

  has_one :melt_pond, dependent: :destroy
  has_one :topography, dependent: :destroy

  accepts_nested_attributes_for :melt_pond, :topography

  scope :primary, -> { where(obs_type: 'primary') }
  scope :secondary, -> { where(obs_type: 'secondary') }
  scope :tertiary, -> { where(obs_type: 'tertiary') }

  validates :obs_type, uniqueness: { scope: :observation_id }

  with_options allow_blank: true do |record|
    record.validates :partial_concentration, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
    record.validates :thickness,  numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    record.validates :snow_thickness,  numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    record.validates :obs_type, inclusion: { in: %w(primary secondary tertiary) }
    record.validates_with Validations::LookupCodeValidator, fields: {
      ice_lookup: 'ice_lookup',
      floe_size_lookup: 'floe_size_lookup',
      snow_lookup: 'snow_lookup',
      algae_lookup: 'algae_lookup',
      algae_density_lookup: 'algae_density_lookup',
      algae_location_lookup: 'algae_location_lookup',
      sediment_lookup: 'sediment_lookup' }
  end

  validate :ice_types_with_ten_codes_cant_have_floe_size

  def ice_type
    case ice_lookup.try(:code)
    when *IceLookup::OLD_ICE then 'old'
    when *IceLookup::NEW_ICE then 'new'
    when *IceLookup::FIRST_YEAR_ICE then 'first-year'
    when *IceLookup::OTHER then 'other'
    end
  end

  def as_csv
    [
      partial_concentration,
      ice_lookup.try(:code),
      thickness,
      floe_size_lookup.try(:code),
      snow_lookup.try(:code),
      snow_thickness,
      topography.as_csv,
      melt_pond.as_csv,
      algae_lookup.try(:code),
      sediment_lookup.try(:code),
      algae_density_lookup.try(:code),
      algae_location_lookup.try(:code)
    ]
  end

  private

  def ice_types_with_ten_codes_cant_have_floe_size
    return unless %w(Shuga Frazil Grease Slush).include?(ice_lookup.try(:name))
    return if floe_size_lookup.nil?

    errors.add(:ice_lookup_id, "#{ice_lookup.name} cannot have a floe size")
  end
end
