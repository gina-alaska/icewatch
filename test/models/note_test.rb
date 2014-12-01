require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  should belong_to(:observation)
end
