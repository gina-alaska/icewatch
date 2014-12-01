require 'test_helper'

class ObservationTest < ActiveSupport::TestCase
  should belong_to(:cruise)
  should belong_to(:ship).through(:cruise)

  should have_one(:primary_observer).class_name('Person')
  should have_one(:primary_ice_observation).class_name('IceObservation').dependent(:destroy)
  should have_one(:secondary_ice_observation).class_name('IceObservation').dependent(:destroy)
  should have_one(:tertiary_ice_observation).class_name('IceObservation').dependent(:destroy)
  should have_one(:ice).dependent(:destroy)

  should have_many(:additional_observers).class_name('Person')
  should have_many(:photos).dependent(:destroy)
  should have_many(:comments).dependent(:destroy)
  should have_many(:fauna).dependent(:destroy)
  should have_many(:notes).dependent(:destroy)

  # should accept_nested_attributes_for()

end
