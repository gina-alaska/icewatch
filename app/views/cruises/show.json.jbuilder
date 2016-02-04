json.extract! @cruise, :starts_at, :ends_at, :objective, :captain, :chief_scientist
json.primary_observer @cruise.primary_observer.try(:name)
