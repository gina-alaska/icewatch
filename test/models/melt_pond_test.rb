require 'test_helper'

class MeltPondTest < ActiveSupport::TestCase
  should belong_to(:ice_observation)
  should belong_to(:max_depth_lookup).class_name('Lookup')
  should belong_to(:surface_lookup).class_name('Lookup')
  should belong_to(:pattern_lookup).class_name('Lookup')
  should belong_to(:bottom_type_lookup).class_name('Lookup')

end
