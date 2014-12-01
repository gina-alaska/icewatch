require 'test_helper'

class IceTest < ActiveSupport::TestCase
  should belong_to(:observation)
  should belong_to(:thin_ice_lookup)
  should belong_to(:thick_ice_lookup)
  should belong_to(:open_water_lookup).class_name('Lookup')

end
