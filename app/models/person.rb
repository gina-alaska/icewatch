class Person < ActiveRecord::Base
  has_many :person_observations
  has_many :observations, through: :person_observations
  has_many :comments
  has_many :cruises

  validates_presence_of :name

  def self.find_or_create_by_id_or_name(id_or_name)
    where(id: id_or_name).first || find_or_create_by(name: id_or_name)
  end
end
