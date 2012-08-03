class MeltPond
  include Mongoid::Document

  embedded_in :ice_observation
end