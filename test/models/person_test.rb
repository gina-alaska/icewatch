require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  should have_many(:observations)
  should have_many(:cruises)
end
