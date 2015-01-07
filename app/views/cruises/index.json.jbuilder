json.array!(@cruises) do |cruise|
  json.extract! cruise, :starts_at, :ends_at, :objective, :captain, :primary_observer, :chief_scientist
  json.array! cruise.observations, partial: 'observations/observation', as: :observation
end
