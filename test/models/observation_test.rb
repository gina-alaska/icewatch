require 'test_helper'

class ObservationTest < ActiveSupport::TestCase
  should belong_to(:cruise)

  should have_one(:ship)
  should have_one(:primary_observer)
  should have_one(:primary_ice_observation).class_name('IceObservation').dependent(:destroy)
  should have_one(:secondary_ice_observation).class_name('IceObservation').dependent(:destroy)
  should have_one(:tertiary_ice_observation).class_name('IceObservation').dependent(:destroy)
  should have_one(:ice).dependent(:destroy)

  should have_many(:additional_observers)
  should have_many(:photos).dependent(:destroy)
  should have_many(:comments).dependent(:destroy)
  should have_many(:faunas).dependent(:destroy)
  should have_many(:notes).dependent(:destroy)

  # should accept_nested_attributes_for()
  def setup
    @observation = observations(:base)
  end

  def test_minimal_observation_is_valid
    assert @observation.partial_and_total_concentrations_equal?, @observation.observation_partial_concentrations
    assert @observation.valid?, @observation.errors.full_messages
  end

  def test_partial_concentrations_equal_total_concentration
    @observation.ice.total_concentration = 10
    @observation.primary_ice_observation.partial_concentration = 3
    @observation.secondary_ice_observation.partial_concentration = 2
    @observation.tertiary_ice_observation.partial_concentration = 1

    refute @observation.partial_and_total_concentrations_equal?, @observation.ice.total_concentration
    # assert_equal ['Partial concentrations must equal total concentration'], @observation.ice.errors.messages[:total_concentration]
    # assert_equal ['Sum of partial concentrations must equal total concentration'], @observation.primary_ice_observation.errors.messages[:partial_concentration]
    # assert_equal ['Sum of partial concentrations must equal total concentration'], @observation.secondary_ice_observation.errors.messages[:partial_concentration]
    # assert_equal ['Sum of partial concentrations must equal total concentration'], @observation.tertiary_ice_observation.errors.messages[:partial_concentration]
  end

  def test_observation_partial_contentations
    @observation.primary_ice_observation.partial_concentration = 3
    @observation.secondary_ice_observation.partial_concentration = 2
    @observation.tertiary_ice_observation.partial_concentration = 1

    assert_equal [3,2,1], @observation.observation_partial_concentrations
  end

  def test_ice_type_in_increasing_order
    fast_ice = lookups('fast-ice'.to_sym)

    assert @observation.ice_type_in_increasing_order?(nil, nil)
    assert @observation.ice_type_in_increasing_order?(fast_ice, lookups(:frazil))
    assert @observation.ice_type_in_increasing_order?(fast_ice, lookups(:shuga))
    assert @observation.ice_type_in_increasing_order?(fast_ice, lookups(:grease))
    assert @observation.ice_type_in_increasing_order?(fast_ice, lookups(:pancakes))
    assert @observation.ice_type_in_increasing_order?(fast_ice, lookups(:brash))

    assert @observation.ice_type_in_increasing_order?(lookups(:multiyear), fast_ice)
    assert @observation.ice_type_in_increasing_order?(lookups(:multiyear), lookups(:multiyear))
    refute @observation.ice_type_in_increasing_order?(fast_ice, lookups(:multiyear))
  end

end
