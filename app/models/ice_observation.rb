class IceObservation < ActiveRecord::Base
  belongs_to :observation
  belongs_to :algae_lookup
  belongs_to :algae_density_lookup
  belongs_to :algae_location_lookup
  belongs_to :floe_size_lookup
  belongs_to :ice_lookup
  belongs_to :sediment_lookup
  belongs_to :snow_lookup

  has_one :melt_pond
  has_one :topography

  accepts_nested_attributes_for :melt_pond, :topography

  scope :primary, -> { where(obs_type: 'primary') }
  scope :secondary, -> { where(obs_type: 'secondary') }
  scope :tertiary, -> { where(obs_type: 'tertiary') }

  validates_uniqueness_of :obs_type, scope: :observation_id

  with_options allow_blank: true do |record|
    record.validates :partial_concentration, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10}
    record.validates :thickness,  numericality: {only_integer: true, greater_than_or_equal_to: 0 }
    record.validates :snow_thickness,  numericality: {only_integer: true, greater_than_or_equal_to: 0 }
    record.validates :obs_type, inclusion: {in: %w(primary secondary tertiary)}
    record.validates_with Validations::LookupCodeValidator, fields: {
      ice_lookup: 'ice_lookup',
      floe_size_lookup: 'floe_size_lookup',
      snow_lookup: 'snow_lookup',
      biota_lookup: 'biota_lookup',
      biota_density_lookup: 'biota_density_lookup',
      biota_location_lookup: 'biota_location_lookup',
      sediment_lookup: 'sediment_lookup'}
  end
end
