json.extract! @meteorology, :id, :observation_id, :weather_lookup_id,
  :visibility_lookup_id, :total_cloud_cover, :wind_speed, :wind_direction,
  :air_temperature, :water_temperature, :realtive_humidity, :air_pressure,
  :created_at, :updated_at
