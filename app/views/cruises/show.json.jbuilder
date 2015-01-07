json.extract! @cruise, :starts_at, :ends_at, :objective, :captain, :primary_observer, :chief_scientist
json.observations do
  json.array! @cruise.observations, partial: 'observations/observation', as: :observation
end