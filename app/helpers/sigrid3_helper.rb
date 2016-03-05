module Sigrid3Helper
  def self.ice_concentration(assist_value)
    case assist_value
    when nil
      '55'
    when 0
      '01'
    when 10
      '92'
    else
      (assist_value * 10).to_s
    end
  end

  def self.ice_thickness(observation)
    if observation.ice.total_concentration.nil? or observation.ice.total_concentration == 0
      0
    elsif partial_without_thickness(observation)
      nil
    else
      (
        ice_percent_thickness(observation.primary) +
        ice_percent_thickness(observation.secondary) +
        ice_percent_thickness(observation.tertiary)
      ) / observation.ice.total_concentration
    end
  end

  def self.water_coverage_area(observation)
    if observation.ice.total_concentration.nil? or observation.ice.total_concentration == 0
      0
    elsif partial_without_surface_coverage(observation)
      nil
    else
      (
      melt_pond_percent_coverage(observation.primary) +
      melt_pond_percent_coverage(observation.secondary) +
      melt_pond_percent_coverage(observation.tertiary)
      ) / observation.ice.total_concentration
    end
  end

  def self.form_of_water(open_water_code)
    case open_water_code
    when 1, 2
      1
    when 6
      3
    when 7
      5
    else
      nil
    end
  end

  def self.snow_type(snow_code)
    case snow_code
    when 2, 3, 4, 7, 11
      0
    else
      nil
    end
  end

  def self.topographic_nature(topo_code)
    case topo_code
    when 200, 400
      1
    when 500
      3
    else
      nil
    end
  end

  def self.melt_pond_percent_coverage(ice_observation)
    if ice_observation.partial_concentration.nil? or ice_observation.melt_pond.surface_coverage.nil?
      0
    else
      ice_observation.partial_concentration * ice_observation.melt_pond.surface_coverage
    end
  end

  def self.ice_percent_thickness(ice_observation)
    if ice_observation.partial_concentration.nil?
      0
    else
      ice_observation.partial_concentration * ice_observation.thickness
    end
  end

  def self.stage_of_development(ice_type_code, thickness)
    case ice_type_code
    when 10, 11
      '81'
    when 20
      '82'
    when 30
      if !thickness.nil? and thickness >= 10 and thickness <= 30
        '84'
      elsif !thickness.nil? and thickness > 30 and thickness <= 70
        '87'
      else
        '80'
      end
    when 40
      '84'
    when 50
      '85'
    when 60
      '87'
    when 70
      '91'
    when 80
      '93'
    when 75
      '96'
    when 85
      '97'
    when 90
      '70'
    when 95
      # TODO: I need a code here
      '80'
    else
      '80'
    end
  end

  def self.form_of_ice(floe_size)
    case floe_size
    when 100
      "22"
    when 200
      "21"
    when 300
      "01"
    when 400
      "02"
    when 500
      "03"
    when 600
      "04"
    when 700
      "05"
    when 800
      "06"
    when 900
      "09"
    else
      "99"
    end
  end

  def self.partial_without_thickness(observation)
    partial_concentrations = observation.ice_observations.select(&:partial_concentration)
    partial_concentrations.reject!(&:thickness)
    partial_concentrations.any?
  end

  def self.partial_without_surface_coverage(observation)
    partial_concentrations = observation.ice_observations.select(&:partial_concentration)
    partial_concentrations.reject! { |i| i.melt_pond.surface_coverage }
    partial_concentrations.any?
  end

  def self.has_brash_ice_with_thickness(ice_observations)
    # Group ice observations by ice_lookup_code and thickness
    brash_obs = Array(ice_observations).collect { |i| [i.ice_lookup.try(:code), i.thickness] }
    # Select any that have both code of 90 and thickness is not nil
    brash_obs.select { |b| b.first == 90 and !b.last.nil? }.any?
  end

  def self.brash_observation(observation)
    %w{primary secondary tertiary}.each do |type|
      ice_obs = observation.send(type.to_sym)
      return ice_obs if has_brash_ice_with_thickness(ice_obs)
    end

    nil
  end
end
