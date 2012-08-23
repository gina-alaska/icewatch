class Observation
  include Mongoid::Document
  include AssistShared::Validations::Observation
  include AssistShared::CSV::Observation
  
  before_validation :check_imported_as_cruise_id
  
  validates_presence_of :cruise_id
  validate :absence_of_imported_as_cruise_id
  
  field :obs_datetime, type: Time
  field :accepted, type: Boolean, default: false
  field :is_valid, type: Boolean, default: false
  field :hexcode, type: String
  
  embeds_one :ice
  embeds_one :meteorology
  embeds_many :ice_observations do
    def obs_type type
      where(obs_type: type).first
    end
    def primary
      obs_type 'primary'
    end
    def secondary
      obs_type 'secondary'
    end
    def tertiary
      obs_type 'tertiary'
    end
  end
  
  embeds_many :photos
  embeds_many :comments
  
  belongs_to :cruise

  accepts_nested_attributes_for :ice, :ice_observations, :meteorology, :photos, :comments
  
  default_scope desc(:obs_datetime).where(accepted: true )
  
  scope :has_errors, where(:is_valid => false)
  scope :pending, where(:accepted => false)
  

  def as_geojson opts={}
    {
      type: "Feature",
      geometry: {
        type: "Point",
        coordinates: [self.longitude, self.latitude]
      },
      attributes: self.as_json
    }
  end


  def check_imported_as_cruise_id
    if self.attributes.has_key? "imported_as_cruise_id"
      self.attributes.delete("imported_as_cruise_id") if self.attributes["imported_as_cruise_id"] == self.cruise_id.to_s
    end
  end
  
  def absence_of_imported_as_cruise_id
    errors.add(:cruise_id, "Cruise ID's do not match") if self.attributes.has_key? "imported_as_cruise_id"
  end

      
end
