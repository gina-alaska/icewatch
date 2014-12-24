class Cruise < ActiveRecord::Base
  has_many :observations

  validates_presence_of :ship, :starts_at, :ends_at, :primary_observer,
                        :chief_scientist, :objective

  # validates_presense_of :captain, :archived, :approved
  validates_length_of :objective, {maximum: 300}

  def build_observation
    observation = self.observations.new
    observation.build_ship
    observation.build_ice
    observation.build_primary_ice_observation do |obs|
      obs.build_topography
      obs.build_melt_pond
    end
    observation.build_secondary_ice_observation do |obs|
      obs.build_topography
      obs.build_melt_pond
    end
    observation.build_tertiary_ice_observation do |obs|
      obs.build_topography
      obs.build_melt_pond
    end
    observation.build_meteorology do |met|
      met.build_high_cloud
      met.build_medium_cloud
      met.build_low_cloud
    end
    observation.faunas.build
    3.times{ observation.notes.build }
    observation
  end

end
