json.extract! @cruise, :starts_at, :ends_at, :objective, :ship, :captain, :primary_observer, :chief_scientist
json.observations do
  json.array! @observations, partial: 'observations/observation', as: :observation
end
