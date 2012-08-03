class Comment
  include Mongoid::Document

  embedded_in :ice_observation
end