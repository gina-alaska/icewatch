class MeltPond < ActiveRecord::Base
  belongs_to :ice_observation
  belongs_to :max_depth_lookup
  belongs_to :surface_lookup
  belongs_to :pattern_lookup
  belongs_to :bottom_type_lookup
end
