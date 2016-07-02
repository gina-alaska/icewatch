require 'test_helper'

class LocationConcernsTest < ActiveSupport::TestCase
  def setup
    @location = OpenStruct.new
    @location.extend(Location)
  end

  def test_parse_ddm
    assert_in_delta  64.8378, @location.parse_ddm(64, 50.268), 0.001
    assert_in_delta -64.8378, @location.parse_ddm(-64, 50.268), 0.001
  end

  def test_parse_dms
    assert_in_delta  64.8378, @location.parse_dms(64, 50, 16.080), 0.001
    assert_in_delta -64.8378, @location.parse_dms(-64, 50, 16.080), 0.001
  end

  def test_resolve_latitude_nil
    @location.latitude = nil
    
    assert_nil @location.latitude
  end

  def test_resolve_latitude_dd
    @location.latitude = 64.8378
    @location.resolve_latitude

    assert_in_delta 64.8378, @location.latitude, 0.001
  end

  def test_resolve_latitude_ddm
    @location.latitude = 64
    @location.lat_minutes = 50.268
    @location.resolve_latitude

    assert_in_delta 64.8378, @location.latitude, 0.001
  end

  def test_resolve_latitude_dms
    @location.latitude = 64
    @location.lat_minutes = 50
    @location.lat_seconds = 16.080
    @location.resolve_latitude

    assert_in_delta 64.8378, @location.latitude, 0.001
  end
end