json.type "FeatureCollection"
json.features do
  json.array! cruise.observations, partial: 'sigrid3/observations/observation', as: :observation
end
