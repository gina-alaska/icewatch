class Person < ActiveRecord::Base
  has_many :person_observations
  has_many :observations, through: :person_observations

end
