require 'test_helper'

class TopographyTest < ActiveSupport::TestCase
  should belong_to(:ice_observation)
  should belong_to(:topography_lookup)
end
