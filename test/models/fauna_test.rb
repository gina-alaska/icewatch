require 'test_helper'

class FaunaTest < ActiveSupport::TestCase
  should belong_to(:observation)
end
