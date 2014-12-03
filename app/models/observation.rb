class Observation < ActiveRecord::Base
  belongs_to :cruise

  has_one :primary_observer, class_name: 'Person'
  has_one :primary_ice_observation, class_name: 'IceObservation'
  has_one :secondary_ice_observation, class_name: 'IceObservation'
  has_one :tertiary_ice_observation, class_name: 'IceObservation'
  has_one :ice
  has_one :meteorology
  has_one :ship
  has_many :ice_observations
  has_many :additional_obsevers, class_name: 'Person'
  has_many :fauna
  has_many :comments

  accepts_nested_attributes_for :ice, :ice_observations, :meteorology,
                                :comments, :nots, :faunas, :ship
end
