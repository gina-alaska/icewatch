class Topography
  include Mongoid::Document

  embedded_in :ice_observation
end