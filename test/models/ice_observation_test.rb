require 'test_helper'

class IceObservationTest < ActiveSupport::TestCase
  should have_one(:melt_pond).dependent(:destroy)
  should have_one(:topography).dependent(:destroy)

  should belong_to(:observation)
  should belong_to(:floe_size_lookup)
  should belong_to(:snow_lookup)
  should belong_to(:ice_lookup)
  should belong_to(:algae_lookup)
  should belong_to(:algae_density_lookup)
  should belong_to(:algae_location_lookup)
  should belong_to(:sediment_lookup)

  def test_frazil_shuga_grease_floe_size_validation
    %w(frazil shuga grease slush).each do |ice_type|
      ice_observation = IceObservation.new(
        floe_size_lookup: lookups('brash-broken-ice'.to_sym),
        ice_lookup: lookups(ice_type.to_sym)
      )
      refute ice_observation.valid?, "#{ice_type} with floe size should not be valid"
    end
  end
end
