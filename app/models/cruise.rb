class Cruise < ActiveRecord::Base
  include PrimaryObserver
  include Zippable
  include Importable::Cruise

  has_many :observations
  has_many :uploaded_files
  has_many :photos, dependent: :destroy
  has_and_belongs_to_many :users
  belongs_to :primary_observer, class_name: Person

  validates_presence_of :ship, :starts_at, :ends_at, :objective
  validates_length_of :objective, maximum: 300

  scope :start_dates, -> { order(starts_at: :desc).pluck(:starts_at) }
  scope :for_year, -> (year) do
    date = Time.new(year)
    where(starts_at: [date.beginning_of_year..date.end_of_year])
  end
  scope :approved, -> { where(approved: true) }

  delegate :year, to: :starts_at

  def build_observation
    observation = observations.new
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
    3.times { observation.notes.build }
    observation
  end

  def render_to_string(obs, format = :json)
    ActionView::Base.new(Rails.configuration.paths['app/views'])
      .render(template: "cruises/show.#{format}", format: format, locals: { :@cruise => self, :@observations => obs  })
  end

  def to_s
    "#{ship}-#{starts_at.strftime('%Y%m%d')}-#{ends_at.strftime('%Y%m%d')}"
  end

  def export_path
    File.join(EXPORT_PATH, relative_export_path)
  end

  def relative_export_path
    File.join('observations', to_s)
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

  def locked?
    archived
  end

  def batch_approve_observations(filter_invalid = true)
    observations.each do |observation|
      next if filter_invalid && !observation.may_accept?

      observation.update_attribute(:status, 'accepted')
    end
  end

  def grouped_observed_ice_types
    observations.map(&:observed_ice_types).flatten.inject(Hash.new(0)) do |h, i|
      ice_type = i.try(:name) || 'No Observation'
      h[ice_type] += 1
      h
    end
  end

  def self.csv_headers
    %w{ ship captain chief_scientist primary_observer
        objective starts_at ends_at }.join(",")
  end

  def as_csv
    [
      ship,
      captain,
      chief_scientist,
      primary_observer.try(:name),
      objective,
      starts_at,
      ends_at
    ]
  end
end
