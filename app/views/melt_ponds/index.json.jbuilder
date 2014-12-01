json.array!(@melt_ponds) do |melt_pond|
  json.extract! melt_pond, :id, :ice_observation_id, :max_depth_lookup_id, :surface_lookup_id, :pattern_lookup_id, :bottom_type_lookup_id, :surface_coverage, :freeboard, :dried_ice, :rotten_ice
  json.url melt_pond_url(melt_pond, format: :json)
end
