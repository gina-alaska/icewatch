json.array!(@comments) do |comment|
  json.extract! comment, :id, :text, :commentable_id, :commentable_type, :person_id
  json.url comment_url(comment, format: :json)
end
