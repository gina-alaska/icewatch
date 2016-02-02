require 'test_helper'

class CloudTest < ActiveSupport::TestCase
  should belong_to(:meteorology)
  should belong_to(:cloud_lookup)


end
