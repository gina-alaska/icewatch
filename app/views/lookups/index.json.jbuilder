json.array!(@lookups) do |lookup|
  json.extract! lookup, :id, :code, :name, :type, :comment
  json.url lookup_url(lookup, format: :json)
end
