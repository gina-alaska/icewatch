require 'test_helper'

class CsvObservationTest < ActiveSupport::TestCase

  test 'csvobservation handles assignment correctly' do
    csvobservation = CsvObservation.new({ 'foo' => 'bar'})
    assert_raise NoMethodError do
      csvobservation.foo
    end

    assert_includes csvobservation.errors.full_messages, "Unknown field: 'FOO'"

  end

end
