json.type "Feature"
json.geometry do
  json.type "Point"
  json.coordinates [observation.longitude, observation.latitude]
end

json.properties do |prop|
  prop.CT  Sigrid3Helper.ice_concentration(observation.ice.total_concentration)
  prop.CTA Sigrid3Helper.ice_concentration(observation.primary.partial_concentration)
  prop.CTB Sigrid3Helper.ice_concentration(observation.secondary.partial_concentration)
  prop.CTC Sigrid3Helper.ice_concentration(observation.tertiary.partial_concentration)
  prop.DO  "1"
  prop.WO  "1"
  prop.SO  "1"
  prop.PO  "1"
  prop.RO  "1"

  ice_thickness = Sigrid3Helper.ice_thickness(observation)
  prop.EM  ice_thickness
  prop.EO  "1" if !ice_thickness.nil? and ice_thickness > 0

  if Sigrid3Helper.has_brash_ice_with_thickness(observation.ice_observations)
    obs = Sigrid3Helper.brash_observation(observation)
    if obs.thickness >= 400
      prop.AV = obs.thickness
    elsif obs.thickness.between?(200, 399)
      prop.AK = obs.thickness
    elsif obs.thickness.between?(100, 199)
      prop.AM = obs.thickness
    else
      prop.AT = obs.thickness
    end
  end

  prop.SW  Sigrid3Helper.water_coverage_area(observation)

  prop.SA  Sigrid3Helper.stage_of_development(
            observation.primary.ice_lookup.try(:code),
            observation.primary.thickness)
  prop.SB  Sigrid3Helper.stage_of_development(
            observation.secondary.ice_lookup.try(:code),
            observation.secondary.thickness)
  prop.SC  Sigrid3Helper.stage_of_development(
            observation.tertiary.ice_lookup.try(:code),
            observation.tertiary.thickness)
  prop.CN  Sigrid3Helper.stage_of_development(
            observation.ice.thin_ice_lookup.try(:code),
            0)
  prop.CD  Sigrid3Helper.stage_of_development(
            observation.ice.thick_ice_lookup.try(:code),
            0)
  prop.FA  Sigrid3Helper.form_of_ice(observation.primary.floe_size_lookup.try(:code))
  prop.FB  Sigrid3Helper.form_of_ice(observation.secondary.floe_size_lookup.try(:code))
  prop.FC  Sigrid3Helper.form_of_ice(observation.tertiary.floe_size_lookup.try(:code))
  prop.WF  Sigrid3Helper.form_of_water(observation.ice.open_water_lookup.try(:code))
  prop.SM  Sigrid3Helper.snow_type(observation.primary.snow_lookup.try(:code))
  prop.RN  Sigrid3Helper.topographic_nature(observation.primary.topography.topography_lookup.try(:code))
end
