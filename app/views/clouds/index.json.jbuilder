json.array!(@clouds) do |cloud|
  json.extract! cloud, :id, :meteorology_id, :cloud_lookup_id, :cover, :height, :cloud_type
  json.url cloud_url(cloud, format: :json)
end
