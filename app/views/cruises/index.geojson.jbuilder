json.type 'FeatureCollection'
json.features @cruises do |cruise|
  next if cruise.observations.empty?
  json.partial! 'observations/observation', collection: cruise.observations, as: :observation
end