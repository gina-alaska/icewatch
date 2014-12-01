json.array!(@topographies) do |topography|
  json.extract! topography, :id, :ice_observation_id, :old, :snow_covered, :concentration, :ridge_height, :topography_lookup_id
  json.url topography_url(topography, format: :json)
end
