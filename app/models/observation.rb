class Observation < ActiveRecord::Base
  include IceTypes
  belongs_to :cruise

  has_many :person_observations
  has_many :observers, through: :person_observations, class_name: :person

  has_one :primary_person_observation, -> { primary },
          class_name: 'PersonObservation'
  has_one :primary_observer, through: :primary_person_observation, source: :person
  has_many :additional_person_observations, -> { additional },
          class_name: 'PersonObservation'
  has_many :additional_observers, through: :additional_person_observations, source: :person

  has_many :ice_observations
  has_one :primary_ice_observation, -> { primary }, class_name: 'IceObservation'
  has_one :secondary_ice_observation, -> { secondary }, class_name: 'IceObservation'
  has_one :tertiary_ice_observation, -> { tertiary }, class_name: 'IceObservation'

  has_one :ice
  has_one :meteorology
  has_one :ship
  has_many :faunas
  has_many :comments
  has_many :notes

  accepts_nested_attributes_for :ice, :ice_observations, :meteorology,
                                :comments, :notes, :faunas, :ship,
                                :primary_observer, :additional_observers

  def primary_observer_attributes= attrs
    self.primary_observer = Person.where(attrs).first_or_initialize
  end

  validates_presence_of :primary_observer, :observed_at, :latitude, :longitude

  validate :location
  validate :partial_concentrations_equal_total_concentration
  validate :ice_thickness_are_decreasing_order
  validate :ice_lookup_codes
  validate :ice_lookup_codes_are_increasing_order

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
end
