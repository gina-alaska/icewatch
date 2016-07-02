module Location
  extend ActiveSupport::Concern

  included do
    before_save :resolve_latitude
    before_save :resolve_longitude

    validate :location
  end

  attr_reader :lat_minutes, :lat_seconds, :lon_minutes, :lon_seconds

  def lat_minutes=(minutes)
    @lat_minutes = minutes.to_f
  end

  def lat_seconds=(seconds)
    @lat_seconds = seconds.to_f
  end

  def lon_minutes=(minutes)
    @lon_minutes = minutes.to_f
  end

  def lon_seconds=(seconds)
    @lon_seconds = seconds.to_f
  end

  def location
    errors.add(:latitude, 'Latitude must be between -90 and 90') unless latitude.to_f <= 90 && latitude.to_f >= -90
    errors.add(:longitude, 'Longitude must be between -180 and 180') unless longitude.to_f <= 180 && longitude.to_f >= -180
  end

  def resolve_latitude
    return if latitude.nil?
    l = case
        when !lat_seconds.nil?
          parse_dms(latitude, lat_minutes, lat_seconds)
        when !lat_minutes.nil?
          parse_ddm(latitude, lat_minutes)
        else
          latitude
        end

    self.latitude = l.round(4)
  end

  def resolve_longitude
    return if longitude.nil?
    l = case
        when !lon_seconds.nil?
          parse_dms(longitude, lon_minutes, lon_seconds)
        when !lon_minutes.nil?
          parse_ddm(longitude, lon_minutes)
        else
          longitude
        end

    self.longitude = l.round(4)
  end

  def parse_ddm(d, m)
    decimal = m / 60.0

    if d >= 0
      d + decimal
    else
      d - decimal
    end
  end

  def parse_dms(d, m, s)
    decimal = (m * 60 + s) / 3600.0

    if d >= 0
      d + decimal
    else
      d - decimal
    end
  end
end
