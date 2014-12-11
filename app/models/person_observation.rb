class PersonObservation < ActiveRecord::Base
  belongs_to :person
  belongs_to :observation

  scope :primary, -> { where(primary: true) }
  scope :additional, -> { where(primary: false) }
end
