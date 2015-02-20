require 'test_helper'

class IceObservationTest < ActiveSupport::TestCase
  should have_one(:melt_pond).dependent(:destroy)
  should have_one(:topography).dependent(:destroy)

  should belong_to(:observation)
  should belong_to(:floe_size_lookup).class_name('Lookup')
  should belong_to(:snow_lookup).class_name('Lookup')
  should belong_to(:ice_lookup).class_name('Lookup')
  should belong_to(:algae_lookup).class_name('Lookup')
  should belong_to(:algae_density_lookup).class_name('Lookup')
  should belong_to(:algae_location_lookup).class_name('Lookup')
  should belong_to(:sediment_lookup).class_name('Lookup')


  def test_frazil_shuga_grease_floe_size_validation
    ice_observation = ice_observations(:primary)
    %w(frazil shuga grease).each do |ice_type|
      ice_observation.ice_lookup = lookups(ice_type.to_sym)
      refute ice_observation.valid?
    end
  end
end
