json.array!(@ice_observations) do |ice_observation|
  json.extract! ice_observation, :id, :observation_id, :floe_size_lookup_id, :snow_lookup_id, :ice_lookup_id, :algae_lookup_id, :algae_density_lookup_id, :algae_density_lookup_id, :sediment_lookup_id, :partial_concentration, :thickness, :snow_thickness, :obs_type
  json.url ice_observation_url(ice_observation, format: :json)
end
