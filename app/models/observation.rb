class Observation < ActiveRecord::Base
  include IceTypes
  include AASM

  aasm column: 'status' do
    state :saved, initial: true
    state :reviewing
    state :accepted
    state :rejected
    state :locked


    event :review do
      transitions from: [:saved, :rejected], to: :reviewing, guard: :valid?
    end

    event :accept do
      transitions from: :reviewing, to: :accepted, guard: :valid?
    end

    event :reject do
      transitions from: :reviewing, to: :rejected
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
  has_many :observers, through: :person_observations, class_name: :person

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
  accepts_nested_attributes_for :faunas, allow_destroy: true, reject_if: ->(f){f['name'].blank?}
  accepts_nested_attributes_for :photos, allow_destroy: true, reject_if: ->(f){f['tempfile'].blank? and f['name'].blank?}

  validates_uniqueness_of :observed_at, scope: [:cruise_id, :latitude, :longitude], message: "This observation already exists"
  validates_presence_of :primary_observer, :observed_at, :latitude, :longitude

  validate :location
  validate :partial_concentrations_equal_total_concentration
  validate :ice_thickness_are_decreasing_order
  validate :ice_lookup_codes
  validate :ice_lookup_codes_are_increasing_order
  validates_associated :ice, :ice_observations, :meteorology, :photos

  attr_writer :primary_observer_id_or_name
  attr_writer :additional_observers_id_or_name

  before_save :resolve_primary_observer
  before_save :resolve_additional_observers

  def resolve_primary_observer
    self.primary_observer = resolve_observer(@primary_observer_id_or_name) unless @primary_observer_id_or_name.blank?
  end

  def resolve_additional_observers
    if @additional_observers_id_or_name.present?
      self.additional_observer_ids = @additional_observers_id_or_name.map{|i| resolve_observer(i).id}
    end
  end

  def resolve_observer id_or_name
    Person.find_or_create_by_id_or_name(id_or_name)
  end

  def additional_observers_id_or_name
    self.additional_observer_ids
  end

  def primary_observer_id_or_name
    self.primary_observer.try(:id)
  end

  def to_s
    timestamp =  if observed_at.present?
      observed_at.strftime("%Y-%m-%d %H:%M")
    else
      "#{self.id}_time_not_specified"
    end
    "#{timestamp} - #{primary_observer.try(:name)}"
  end

  def location
    errors.add(:latitude, "Latitude must be between -90 and 90") unless (latitude.to_f <= 90 && latitude.to_f >= -90)
    errors.add(:longitude, "Longitude must be between -180 and 180") unless (longitude.to_f <= 180 && longitude.to_f >= -180)
  end

  def partial_concentrations_equal_total_concentration
    total_pc = ice_observations.inject(0){|sum,p| sum + p.partial_concentration.to_i}
    primary = primary_ice_observation
    secondary = secondary_ice_observation
    tertiary = tertiary_ice_observation

    if total_pc != 0 and ice.total_concentration != total_pc
      errors.add(:ice, "Partial concentrations must equal total concentration")
      primary.errors.add(:partial_concentration)
      secondary.errors.add(:partial_concentration)
      tertiary.errors.add(:partial_concentration)
    end
  end

  def ice_thickness_are_decreasing_order
    primary = primary_ice_observation
    secondary = secondary_ice_observation
    tertiary = tertiary_ice_observation

    Rails.logger.info(ice_observations)
    Rails.logger.info(primary)

    if primary.thickness and primary.thickness < secondary.thickness.to_i
      secondary.errors.add(:thickness)
      errors.add(:ice, "Primary thickness must be greater than secondary thickness")
    end
    if secondary.thickness and secondary.thickness < tertiary.thickness.to_i
      tertiary.errors.add(:thickness)
      errors.add(:ice, "Secondary thickness must be greater than tertiary thickness")
    end
  end

  def ice_lookup_codes_are_increasing_order
    primary = primary_ice_observation
    secondary = secondary_ice_observation
    tertiary = tertiary_ice_observation

    unless increasing_order?(ice.thick_ice_lookup, primary.ice_lookup)
      errors.add(:ice, "Thick ice type thinner than primary")
      primary.errors.add(:ice_lookup_id)
    end
    unless increasing_order?(primary.ice_lookup, secondary.ice_lookup)
      errors.add(:ice, "Primary ice type thinner than secondary")
      secondary.errors.add(:ice_lookup_id)
    end
    unless increasing_order?(secondary.ice_lookup, tertiary.ice_lookup)
      errors.add(:ice, "Secondary ice type thinner than tertiary")
      tertiary.errors.add(:ice_lookup_id)
    end
    unless increasing_order?(ice.thin_ice_lookup, tertiary.ice_lookup)
      errors.add(:ice, "Tertiary ice type thinner than thin ice type")
      tertiary.errors.add(:ice_lookup_id)
    end

  end

  def ice_lookup_codes
    primary = primary_ice_observation
    secondary = secondary_ice_observation
    tertiary = tertiary_ice_observation

    if (secondary.ice_lookup and !primary.ice_lookup)
      errors.add(:ice, "Secondary ice type without primary")
      secondary.errors.add(:ice_lookup_id)
    end
    if (tertiary.ice_lookup and !secondary.ice_lookup)
      errors.add(:ice, "Tertiary ice type without primary")
      tertiary.errors.add(:ice_lookup_id)
    end
  end

  def increasing_order?(thick, thin)
    always_pass = [10,11,12,30,90]

    return true if (thick.nil? or thin.nil?)
    return true if (always_pass & [thick.code, thin.code]).any?

    ORDERED_CODES.index(thick.code) >= ORDERED_CODES.index(thin.code)
  end

  def thickness_by_ice_type
    ice_observations.group_by(&:ice_type).map{|k,v| {k => v.collect(&:partial_concentration).compact.inject(&:+)}}
  end

  def dominant_ice_type
    thickness_by_ice_type.max{|(ak,av),(bk,bv)| av <=> bv }.keys.first
  end

  def export_path
    File.join(self.cruise.export_path, self.to_s)
  end

  def export_file format
    File.join(export_path, "#{self.to_s}.#{format}")
  end

  def as_csv
    [
      observed_at,
      primary_observer.try(:name),
      (a = additional_observers.map{|o| o.try(:name)}.join(":")).present? ? a : nil,
      latitude,
      longitude,
      ice.as_csv,
      primary_ice_observation.as_csv,
      secondary_ice_observation.as_csv,
      tertiary_ice_observation.as_csv,
      meteorology.as_csv,
      ship.try(:as_csv),
      (f = faunas.map(&:name).join("//")).present? ? f : nil,
      (f = faunas.map(&:count).join("//")).present? ? f : nil,
      photos.count,
      notes.map{|n| n.text.blank? ? nil : n.text},
      (c = self.comments.map {|c|
        c.text.blank? ? nil : "#{c.text} -- #{c.person.try(&:name)}".dump}.join("//")).present? ? c : nil
    ].flatten
  end

  def self.csv_headers
    "Date,PO,AO,LAT,LON,TC,OW,OT,TH,PPC,PT,PZ,PF,PSY,PSH,PTop,PTopC,PRH,POld,PCs,PSC,PMPC,PMPD,PMPP,PMPT,PMPF,PMBT,PMDI,PMRI,PA,PSD,PAD,PAL,SPC,ST,SZ,SF,SSY,SSH,STop,STopC,SRH,SOld,SCs,SSC,SMPC,SMPD,SMPP,SMPT,SMPF,SMBT,SMDI,SMRI,SA,SSD,SAD,SAL,TPC,TT,TZ,TF,TSY,TSH,TTop,TTopC,TRH,TOld,TCs,TSC,TMPC,TMPD,TMPP,TMPT,TMPF,TMBT,TMDI,TMRI,TA,TSD,TAD,TAL,WX,V,HY,HV,HH,MY,MV,MH,LY,LV,LH,TCC,WS,WD,AT,WT,RelH,AP,ShP,ShS,ShH,ShA,FN,FC,Photo,note0,note1,note2,Comments"
  end

  def render_to_string format=:json
    ActionView::Base.new(Rails.configuration.paths['app/views']).
    render(template: "observations/show.#{format.to_s}", format: format, locals: {:@observation => self})
  end

end
