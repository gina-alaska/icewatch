class Cruise < ActiveRecord::Base
  has_many :observations

  validates_presence_of :ship, :starts_at, :ends_at, :primary_observer,
                        :chief_scientist, :objective

  # validates_presense_of :captain, :archived, :approved
  validates_length_of :objective, {maximum: 300}

end
