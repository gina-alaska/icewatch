json.array!(@notes) do |note|
  json.extract! note, :id, :text, :observation_id
  json.url note_url(note, format: :json)
end
