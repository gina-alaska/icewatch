json.type "Feature"
json.geometry do 
  json.type "Point"
  json.coordinates [observation.longitude, observation.latitude]
end

json.properties do |prop|
  prop.CT  Sigrid3.ice_concentration(observation.ice.total_concentration)
  prop.CTA Sigrid3.ice_concentration(observation.ice_observations.primary.partial_concentration)
  prop.CTB Sigrid3.ice_concentration(observation.ice_observations.secondary.partial_concentration)
  prop.CTC Sigrid3.ice_concentration(observation.ice_observations.tertiary.partial_concentration)
  prop.DO  "1"
  prop.WO  "1"
  prop.SO  "1"
  prop.PO  "1"
  prop.RO  "1"

  ice_thickness = Sigrid3.ice_thickness(observation)
  prop.EM  ice_thickness
  prop.EO  "1" if !ice_thickness.nil? and ice_thickness > 0

  if has_brash_ice_with_thickness(observation.ice_observations)
    code, thickness = brash_attributes(observation.ice_observations)
    prop.send(code) = thickness
  end
  
  #prop.??  Sigrid3.brash_thickness(observation)
  prop.SW  Sigrid3.water_coverage_area(observation)
  
  prop.SA  Sigrid3.stage_of_development(
            observation.ice_observations.primary.ice_lookup.try(:code), 
            observation.ice_observations.primary.thickness )
  prop.SB  Sigrid3.stage_of_development(
            observation.ice_observations.secondary.ice_lookup.try(:code), 
            observation.ice_observations.secondary.thickness )
  prop.SC  Sigrid3.stage_of_development(
            observation.ice_observations.tertiary.ice_lookup.try(:code), 
            observation.ice_observations.tertiary.thickness )
  prop.CN  Sigrid3.stage_of_development(
            observation.ice.thin_ice_lookup.try(:code), 
            0 )
  prop.CD  Sigrid3.stage_of_development(
            observation.ice.thick_ice_lookup.try(:code), 
            0  )
  prop.FA  Sigrid3.form_of_ice(observation.ice_observations.primary.floe_size_lookup.try(:code))
  prop.FB  Sigrid3.form_of_ice(observation.ice_observations.secondary.floe_size_lookup.try(:code))
  prop.FC  Sigrid3.form_of_ice(observation.ice_observations.tertiary.floe_size_lookup.try(:code))
  prop.WF  Sigrid3.form_of_water(observation.ice.open_water_lookup.try(:code))
  prop.SM  Sigrid3.snow_type(observation.ice_observations.primary.snow_lookup.try(:code))
  prop.RN  Sigrid3.topographic_nature(observation.ice_observations.primary.topography.topography_lookup.try(:code))
end