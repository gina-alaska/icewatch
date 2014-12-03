class Topography < ActiveRecord::Base
  belongs_to :ice_observation
  belongs_to :topography_lookup
end
