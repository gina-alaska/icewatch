json.extract! observation, :observed_at, :latitude, :longitude, :uuid
json.primary_observer observation.primary_observer.try(:name)
json.additional_observers observation.additional_observers.map(&:name)
json.ice observation.ice, :open_water_lookup_code, :thick_ice_lookup_code,
         :thin_ice_lookup_code, :total_concentration
json.ice_observations do
  json.partial! 'observations/ice_observation', collection: observation.ice_observations, as: :ice_observation
end
json.meteorology do
  json.extract! observation.meteorology, :air_pressure, :air_temperature,
                :relative_humidity, :total_cloud_cover, :visibility_lookup_code, :water_temperature,
                :weather_lookup_code, :wind_direction, :wind_speed
  json.clouds do
    json.partial! 'observations/cloud', collection: observation.meteorology.clouds, as: :cloud
  end
end
json.notes observation.notes.map(&:text)
json.ship observation.ship, :heading, :power, :ship_activity_lookup_code, :speed
json.comments do
  json.partial! 'observations/comments', collection: observation.comments, as: :comment
end
json.photos do
  json.partial! 'observations/photo', collection: observation.photos, as: :photo
end
