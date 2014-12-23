module ObservationsHelper
  def concentration_color(dominant_ice_type)
    case dominant_ice_type
    when 'old'; "#50BBD4"
    when 'new'; "#D9D9D9"
    when 'first_year'; "#BFD7D3"
    when 'other'; "#92A9C4"
    else "#FF0000"
    end
  end

  def concentration_options
    Ice::CONCENTRATION_VALUES.map{|i| [i,i]}
  end

  def ship_power_options
    Ship::POWER_VALUES.map{|i| [i,i]}
  end

  def cloud_cover_options
    Cloud::CLOUD_COVER_VALUES.map{|i| [i,i]}
  end
  
  def yes_no_options
    [['No', 0],['Yes', 1]]
  end
end
