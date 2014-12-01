json.array!(@faunas) do |fauna|
  json.extract! fauna, :id, :name, :count, :observation_id
  json.url fauna_url(fauna, format: :json)
end
