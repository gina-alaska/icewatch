require 'test_helper'

class CruiseTest < ActiveSupport::TestCase
  #should have_many(:observations).dependent(:destroy)

  should belong_to(:primary_observer).class_name('Person')
end
