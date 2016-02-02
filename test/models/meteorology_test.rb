require 'test_helper'

class MeteorologyTest < ActiveSupport::TestCase
  should belong_to(:observation)
  should belong_to(:weather_lookup)
  should belong_to(:visibility_lookup)
end
