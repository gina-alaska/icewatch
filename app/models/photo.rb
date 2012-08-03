class Photo
  include Mongoid::Document

  embedded_in :observation
end