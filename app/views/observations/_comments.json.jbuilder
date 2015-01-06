json.extract! comment, :text
json.person comment.person.try(&:name)