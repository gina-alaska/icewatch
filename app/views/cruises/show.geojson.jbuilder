json.type 'FeatureCollection'
json.features @cruise.observations, partial: 'observations/observation', as: :observation
