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

  # attr_writer :primary_observer_id_or_name
  # attr_writer :captain_id_or_name
  # attr_writer :chief_scientist_id_or_name
  #
  # before_save :resolve_primary_observer
  # before_save :resolve_captain
  # before_save :resolve_chief_scientist
  #
  # def resolve_primary_observer
  #   self.primary_observer = resolve_observer(@primary_observer_id_or_name)
  # end
  # def resolve_captain
  #   self.captain = resolve_observer(@captain_id_or_name)
  # end
  # def resolve_chief_scientist
  #   self.chief_scientist = resolve_observer(@chief_scientist_id_or_name)
  # end
  #
  # def resolve_observer id_or_name
  #   Person.find_or_create_by_id_or_name(id_or_name)
  # end
  #
  # def primary_observer_id_or_name
  #   self.primary_observer.try(:id)
  # end
  # def captain_id_or_name
  #   self.captain.try(:id)
  # end
  # def chief_scienst_id_or_name
  #   self.chief_scientist.try(:id)
  # end

end
