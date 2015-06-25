module ObservationsHelper
  def concentration_color(dominant_ice_type)
    case dominant_ice_type
    when 'old' then '#50BBD4'
    when 'new' then '#D9D9D9'
    when 'first_year' then '#BFD7D3'
    when 'other' then '#92A9C4'
    else '#FF0000'
    end
  end

  def concentration_options(max = nil)
    Ice::CONCENTRATION_VALUES.select { |i| (max.nil? || i.nil?) ? true : i <= max }.map { |i| [i, i] }
  end

  def ship_power_options
    Ship::POWER_VALUES.each_with_index.map { |x, i| [x, i] }
  end

  def cloud_cover_options
    Cloud::CLOUD_COVER_VALUES.map { |i| [i, i] }
  end

  def yes_no_options
    [['No', false], ['Yes', true]]
  end

  def dms(coordinate)
    coordinate = coordinate.to_f
    deg = coordinate < 0 ? coordinate.ceil : coordinate.floor

    min = ((coordinate - deg).abs * 60.0).floor
    sec = ((((coordinate - deg).abs * 60.0) % 1) * 60.0).round
    "DMS: #{deg} #{min} #{sec}"
  end

  def row_highlight(observation)
    if !observation.valid? && !observation.accepted?
      'danger'
    elsif observation.may_accept? && !assist?
      'warning'
    else
      ''
    end
  end
end
