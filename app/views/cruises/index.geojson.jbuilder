json.type 'FeatureCollection'
json.features @cruises.first.observations, partial: 'observations/observation', as: :observation
