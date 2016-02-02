require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  should have_many(:observations)
end
