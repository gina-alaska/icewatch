class IceObservation < ActiveRecord::Base
  include LookupTables::Relations

  belongs_to :observation
  belongs_to :biota_lookup
  belongs_to :biota_density_lookup
  belongs_to :biota_location_lookup
  belongs_to :floe_size_lookup
  belongs_to :ice_lookup
  belongs_to :sediment_lookup
  belongs_to :snow_lookup

  has_one :melt_pond
  has_one :topography

  accepts_nested_attributes_for :melt_pond, :topography
end
