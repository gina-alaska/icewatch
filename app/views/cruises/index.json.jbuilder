json.array!(@cruises) do |cruise|
  json.extract! cruise, :id, :starts_at, :ends_at, :objective, :approved
  json.url cruise_url(cruise, format: :json)
end
