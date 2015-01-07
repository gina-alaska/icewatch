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

  def render_to_string format=:json
    ActionView::Base.new(Rails.configuration.paths['app/views']).
      render(template: "cruises/show.#{format.to_s}", format: format, locals: {:@cruise => self})
  end

  def to_s
    "#{ship}-#{starts_at.strftime("%Y%m%d")}-#{ends_at.strftime("%Y%m%d")}"
  end

  def export_path
    File.join(EXPORT_PATH, self.to_s)
  end

  def metadata
    {
      exported_on: Time.now.utc,
      assist_version: Icewatch::VERSION,
      ship_name: ship,
      captain: captain,
      chief_scientist: chief_scientist,
      primary_observer: primary_observer
    }
  end
end
