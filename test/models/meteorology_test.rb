require 'test_helper'

class MeteorologyTest < ActiveSupport::TestCase
  should belong_to(:observation)
  should belong_to(:weather_lookup).class_name('Lookup')
  should belong_to(:visibility_lookup).class_name('Lookup')
end
