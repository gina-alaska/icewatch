json.type 'Feature'
json.geometry do
  json.type 'Point'
  json.coordinates [observation.longitude, observation.latitude]
end
json.properties do
  json.iceConcentration observation.ice.total_concentration
  json.fillColor concentration_color(observation.dominant_ice_type)
  json.dominantIceType observation.dominant_ice_type
end
