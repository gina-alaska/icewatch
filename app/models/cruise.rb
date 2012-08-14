class Cruise
  include Mongoid::Document
  
  field :ship, type: String
  field :start_date, type: Time
  field :end_date, type: Time
  field :captain, type: String
  field :archived, type: Boolean, default: false
  field :user_id, type: Integer
  field :approved, type: Boolean, default: false
  
  attr_accessible :approved, :ship, :start_date, :end_date, :captain, :archived, :user_id

  has_many :observations, order: 'obs_datetime DESC' do
    def recent count
      desc(:obs_datetime).limit(count)
    end
  end
  
  belongs_to :user
  
  scope :active, ->(){where(:start_date.lte => Time.now).where(:end_date.gte => Time.now)}
  scope :archived, ->(){where(:archived => true)}
  scope :upcoming, ->(){where(:start_date.gte => Time.now)}
  scope :ended, ->(){where(:end_date.lte => Time.now)}
  
  
  validates_presence_of :ship, :start_date, :end_date
  
  def ship_with_date
    "#{self.ship}: #{ymd(start_date)}-#{ymd(end_date)}"
  end
  
  def has_invalid_or_pending_observations? 
    invalid_observations.count + pending_observations.count > 0
  end
  
  def invalid_observations
    self.observations.where(is_valid: false)
  end
  
  def pending_observations
    self.observations.where(accepted: false)
  end
  
  def as_geojson opts={}
    data = self.as_json
    observation = self.observations.recent(1).first
  
    lat, lon = nil
    unless observation.nil?
      lat = observation.delete(:latitude)
      lon = observation.delete(:longitude)
    end
    data[:location] = {
      type: "Feature",
      geometry: {
        type: "Point",
        coordinates: [lat, lon]
      }
    }        
    data
  end  
  
  def as_json opts={}
    data = super
    data[:observations] = self.observations.where(accepted:true)
    
    data
  end
  
private
  def ymd date
    date.strftime("%Y.%m.%d")    
  end
end
