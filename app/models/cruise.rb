class Cruise
  include Mongoid::Document
  
  #ASSIST
  field :assist_uid
  file_accessor :assist
  
  #Cruise metatdata
  field :ship, type: String
  field :start_date, type: Time
  field :end_date, type: Time
  field :primary_observer, type: String
  field :objective, type: String
  
  field :chief_scientist, type: String
  field :captain, type: String

  #Internal metadata
  field :archived, type: Boolean, default: false
  field :user_id, type: Integer
  field :approved, type: Boolean, default: false

  attr_accessible :approved, :ship, :start_date, :end_date, :captain, :primary_observer, :chief_scientist, :objective, :archived, :user_id

  validates_presence_of :ship, :start_date, :end_date, :primary_observer, :objective
  validates_length_of :objective, {maximum: 300}
  
  has_many :observations, order: 'obs_datetime DESC'  do
    def recent count
      desc(:obs_datetime).limit(count)
    end
  end
  
  belongs_to :user
  has_many :uploaded_observations
  
  scope :active, ->(){where(:start_date.lte => Time.zone.now).where(:end_date.gte => Time.zone.now)}
  scope :archived, ->(){where(:archived => true)}
  scope :upcoming, ->(){where(:start_date.gte => Time.zone.now)}
  scope :ended, ->(){where(:end_date.lte => Time.zone.now)}
  
  def ship_with_date
    "#{self.ship}: #{ymd(start_date)}-#{ymd(end_date)}"
  end
  
  def status
    s = if archived?
      "archived"
    elsif start_date >= Time.zone.now
      "upcoming"
    elsif end_date  <= Time.zone.now
      "ended"
    else
      "active"
    end
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
    observation = self.observations.where(accepted:true).last
    return nil if observation.nil? 
    {
      type: "Feature",
      geometry: {
        type: "Point",
        coordinates: [observation.try(:longitude), observation.try(:latitude)]
      },
      attributes: self.as_json
    }   
  end  
  
  def as_json opts={}
    data = super
    data[:observations] = self.observations.where(accepted:true)
    
    data
  end
  
  def length_of_objective
    !self.objective.nil? && self.objective.length <= 300 && self.objective.length > 0
  end

  private
  def ymd date
    date.strftime("%Y.%m.%d")    
  end


  
end
