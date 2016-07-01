class Observation < ActiveRecord::Base
  include IceTypes
  include PrimaryObserver
  include AASM
  include Importable::Observation
  include Exportable

  paginates_per 25

  aasm column: 'status' do
    state :saved, initial: true
    state :accepted
    state :rejected
    state :locked

    event :accept do
      transitions from: :saved, to: :accepted, guard: :valid?
    end

    event :reject do
      transitions from: :saved, to: :rejected
    end

    event :lock do
      transitions from: :accepted, to: :locked
    end

    event :unlock do
      transitions from: :locked, to: :accepeted
    end
  end

  belongs_to :cruise

  has_many :person_observations, dependent: :destroy
  has_many :people, through: :person_observations, source: :person

  has_one :primary_person_observation, -> { primary },
          class_name: 'PersonObservation', dependent: :destroy
  has_one :primary_observer, through: :primary_person_observation, source: :person
  has_many :additional_person_observations, -> { additional },
           class_name: 'PersonObservation', dependent: :destroy
  has_many :additional_observers, through: :additional_person_observations,
                                  source: :person

  has_many :ice_observations, dependent: :destroy
  has_one :primary_ice_observation, -> { primary }, class_name: 'IceObservation',
                                                    dependent: :destroy
  has_one :secondary_ice_observation, -> { secondary }, class_name: 'IceObservation',
                                                        dependent: :destroy
  has_one :tertiary_ice_observation, -> { tertiary }, class_name: 'IceObservation',
                                                      dependent: :destroy
  alias primary primary_ice_observation
  alias secondary secondary_ice_observation
  alias tertiary tertiary_ice_observation

  has_one :ice, dependent: :destroy
  has_one :meteorology, dependent: :destroy
  has_one :ship, dependent: :destroy
  has_many :faunas, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :photos, dependent: :destroy

  accepts_nested_attributes_for :ice, :ice_observations, :meteorology,
                                :comments, :notes, :ship,
                                :primary_observer, :additional_observers,
                                :meteorology
  accepts_nested_attributes_for :faunas, allow_destroy: true, reject_if: ->(f) { f['name'].blank? }
  accepts_nested_attributes_for :photos, allow_destroy: true, reject_if: ->(f) { f['file'].blank? }
  accepts_attachments_for :photos, append: true

  validates_uniqueness_of :observed_at, scope: [:cruise_id, :latitude, :longitude], message: 'This observation already exists'
  validates_presence_of :primary_observer, :observed_at, :latitude, :longitude

  validates_associated :ice, :primary_ice_observation, :secondary_ice_observation,
                       :tertiary_ice_observation, :ship, :meteorology

  validate :location
  validate :partial_concentrations_equal_total_concentration
  validate :ice_thickness_are_decreasing_order
  # validate :ice_lookup_code_presence
  validate :ice_lookup_codes_are_increasing_order
  validate :other_ice_lookup_codes_are_increasing_order

  after_validation :merge_association_errors

  attr_writer :additional_observers_id_or_name

  before_save :resolve_additional_observers

  scope :approved, -> { where(status: 'accepted') }
  scope :unapproved, -> { where(status: 'saved') }

  scope :recent, -> { where("created_at >= :start_date", { start_date: 1.day.ago }) }

  def resolve_additional_observers
    if @additional_observers_id_or_name.present?
      self.additional_observer_ids = @additional_observers_id_or_name.map { |i| resolve_observer(i).id }
    end
  end

  def additional_observers_id_or_name
    additional_observer_ids
  end

  def to_s
    timestamp = if observed_at.present?
                  observed_at.strftime('%Y%m%d%H%M')
                else
                  "#{id}_time_not_specified"
                end
    "#{timestamp}-#{primary_observer.try(:name)}"
  end

  def export_path
    File.join(cruise.export_path, to_s)
  end

  def relative_export_path
    File.join(cruise.relative_export_path, to_s)
  end

  def export_file(format)
    File.join(export_path, "#{self}.#{format}")
  end

  def as_csv
    [
      observed_at,
      primary_observer.try(:name),
      (a = additional_observers.map { |o| o.try(:name) }.join(':')).present? ? a : nil,
      latitude,
      longitude,
      ice.as_csv,
      primary_ice_observation.as_csv,
      secondary_ice_observation.as_csv,
      tertiary_ice_observation.as_csv,
      meteorology.as_csv,
      ship.try(:as_csv),
      (f = faunas.map(&:name).join('//')).present? ? f : nil,
      (f = faunas.map(&:count).join('//')).present? ? f : nil,
      photos.count,
      notes.map { |n| n.text.blank? ? nil : n.text },
      (c = comments.map {|c|
        c.text.blank? ? nil : "#{c.text} -- #{c.person.try(&:name)}".dump}.join('//')).present? ? c : nil
    ].flatten
  end

  def self.csv_headers
    %w{Date PO AO LAT LON TC OW OT TH PPC PT PZ PF PSY PSH PTop PTopC PRH POld
       PCs PSC PMPC PMPD PMPP PMPT PMPF PMBT PMDI PMRI PA PSD PAD PAL SPC ST SZ
       SF SSY SSH STop STopC SRH SOld SCs SSC SMPC SMPD SMPP SMPT SMPF SMBT SMDI
       SMRI SA SSD SAD SAL TPC TT TZ TF TSY TSH TTop TTopC TRH TOld TCs TSC TMPC
       TMPD TMPP TMPT TMPF TMBT TMDI TMRI TA TSD TAD TAL WX V HY HV HH MY MV MH
       LY LV LH TCC WS WD AT WT RelH AP ShP ShS ShH ShA FN FC Photo
       note0 note1 note2 Comments}.join(',')
  end

  def render_to_string(format = :json)
    ActionView::Base.new(Rails.configuration.paths['app/views'].expanded)
      .render(template: "observations/show.#{format}", format: format, locals: { :@observation => self })
  end

  def dominant_ice_type
    thickness_by_ice_type.max { |(_ak, av), (_bk, bv)| av <=> bv }.keys.first
  end

  def partial_and_total_concentrations_equal?
    total_pc = observation_partial_concentrations
    total_pc.empty? || ice.total_concentration == total_pc.sum
  end

  def observation_partial_concentrations
    [primary_ice_observation, secondary_ice_observation, tertiary_ice_observation].map(&:partial_concentration).compact
  end

  def ice_type_in_increasing_order?(thin, thick)
    always_pass = [10, 11, 12, 30, 90]

    return true if thick.nil? || thin.nil?
    return true if (always_pass & [thick.code, thin.code]).any?

    ORDERED_CODES.index(thick.code) >= ORDERED_CODES.index(thin.code)
  end

  def observed_ice_types
    ice_observations.map(&:ice_lookup)
  end

  private

  def location
    errors.add(:latitude, 'Latitude must be between -90 and 90') unless latitude.to_f <= 90 && latitude.to_f >= -90
    errors.add(:longitude, 'Longitude must be between -180 and 180') unless longitude.to_f <= 180 && longitude.to_f >= -180
  end

  def partial_concentrations_equal_total_concentration
    unless partial_and_total_concentrations_equal?
      ice.errors.add(:total_concentration, 'Partial concentrations must equal total concentration')
      primary_ice_observation.errors.add(:partial_concentration, 'Sum of partial concentrations must equal total concentration')
      secondary_ice_observation.errors.add(:partial_concentration, 'Sum of partial concentrations must equal total concentration')
      tertiary_ice_observation.errors.add(:partial_concentration, 'Sum of partial concentrations must equal total concentration')
    end
  end

  def ice_thickness_are_decreasing_order
    if primary.thickness && primary.thickness < secondary.thickness.to_i
      secondary.errors.add(:thickness, 'Primary thickness must be greater than secondary thickness')
    end
    if secondary.thickness && secondary.thickness < tertiary.thickness.to_i
      tertiary.errors.add(:thickness, 'Secondary thickness must be greater than tertiary thickness')
    end
  end

  def ice_lookup_codes_are_increasing_order
    unless ice_type_in_increasing_order?(tertiary.ice_lookup, secondary.ice_lookup)
      tertiary.errors.add(:ice_lookup_id, 'Secondary ice type thinner than tertiary')
    end
    unless ice_type_in_increasing_order?(secondary.ice_lookup, primary.ice_lookup)
      secondary.errors.add(:ice_lookup_id, 'Primary ice type thinner than secondary')
    end
  end

  def other_ice_lookup_codes_are_increasing_order
    unless ice_type_in_increasing_order?(ice.thin_ice_lookup, ice.thick_ice_lookup)
      ice.errors.add(:thick_ice_lookup_id, ' thinner than Thin ice type')
      ice.errors.add(:thin_ice_lookup_id, ' thicker than Thick ice type')
    end
  end

  def ice_lookup_code_presence
    if secondary.ice_lookup && !primary.ice_lookup
      secondary.errors.add(:ice_lookup_id, 'Secondary ice type without primary')
    end
    if tertiary.ice_lookup && !secondary.ice_lookup
      tertiary.errors.add(:ice_lookup_id, 'Tertiary ice type without secondary')
    end
  end

  def thickness_by_ice_type
    ice_observations.group_by(&:ice_type).map { |k, v| { k => v.collect(&:partial_concentration).compact.inject(&:+) } }
  end

  def merge_association_errors
    %w(ship ice primary_ice_observation secondary_ice_observation tertiary_ice_observation meteorology).each do |assoc|
      if send(assoc.to_sym).errors.any?
        send(assoc.to_sym).errors.full_messages.each do |msg|
          errors[:base] << "#{assoc.humanize} error: #{msg}"
        end
      end
    end
    faunas.each do |fauna|
      next if fauna.new_record? # Don't validate unsaved entries.
      # Not sure why fauana validations aren't being run so force it
      fauna.valid?
      if fauna.errors.any?
        fauna.errors.full_messages.each do |msg|
          errors[:base] << "Fauna #{fauna.name} error: #{msg}"
        end
      end
    end
    notes.each do |note|
      note.valid?
      note.errors.full_messages.each do |msg|
        errors[:base] << "Note error: #{msg}"
      end
    end
  end
end
