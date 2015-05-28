require 'test_helper'

class LookupsHelperTest < ActionView::TestCase
  include LookupsHelper
  test 'sort_by_code sorts items correctly' do
    snow_lookups = SnowLookup.all

    sorted_lookups = sort_by_code(snow_lookups)

    assert_equal [0,1,2,3,4,5,6,7,8,9,10,11], sorted_lookups.map{|l| l.code }
  end
end
