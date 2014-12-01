json.array!(@observations) do |observation|
  json.extract! observation, :id, :cruise_id, :observed_at, :latitude, :longitude, :uuid
  json.url observation_url(observation, format: :json)
end
