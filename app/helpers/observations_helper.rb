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
end
