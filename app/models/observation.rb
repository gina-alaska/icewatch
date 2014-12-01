class Observation < ActiveRecord::Base
  belongs_to :cruise
  # belongs_to :ship, through: c

  has_one :primary_observer, class_name: 'Person'
  has_one :primary_ice_observation, class_name: 'IceObservation'
  has_one :secondary_ice_observation, class_name: 'IceObservation'
  has_one :tertiary_ice_observation, class_name: 'IceObservation'
  has_many :additional_obsevers, class_name: 'Person'

end
