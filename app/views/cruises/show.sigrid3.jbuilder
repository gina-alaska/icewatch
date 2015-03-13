json.type "FeatureCollection"
json.features do
  json.array! @cruise.observations, partial: 'observations/observation', as: :observation
end