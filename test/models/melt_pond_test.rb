require 'test_helper'

class MeltPondTest < ActiveSupport::TestCase
  should belong_to(:ice_observation)
  should belong_to(:max_depth_lookup)
  should belong_to(:surface_lookup)
  should belong_to(:pattern_lookup)
  should belong_to(:bottom_type_lookup)

end
