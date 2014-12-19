json.type "Feature"
json.geometry do
  json.type "Point"
  json.coordinates [observation.longitude, observation.latitude]
end
json.properties do
  json.iceConcentration observation.ice.total_concentration
  json.fillColor concentration_color(observation.dominant_ice_type)
  json.dominantIceType observation.dominant_ice_type
  # json.color
end
# json.properties do
#   new_ice_concentration observation.new_ice_con
#   def as_geojson opts={}
#     {
#       type: "Feature",
#       geometry: {
#         type: "Point",
#         coordinates: [self.longitude, self.latitude]
#       },
#       properties: {
#         new_ice_concentration: self.new_ice_concentration * 10,
#         old_ice_concentration: self.old_ice_concentration * 10,
#         first_year_ice_concentration: self.first_year_ice_concentration * 10,
#         total_concentration: self.ice.total_concentration,
#         color: self.concentration_color,
#         strokeColor: self.stroke_color,
#         dominant_ice_type: self.dominant_ice_type.to_s,
#         observation_id: self.id
#       }
#     }
#   end
