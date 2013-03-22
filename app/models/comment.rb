class Comment
  include Mongoid::Document
  
  field :data, type: String

  embedded_in :ice_observation
end