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
  field :cruise_name, type: String
  
  field :chief_scientist, type: String
  field :captain, type: String

  #Internal metadata
  field :archived, type: Boolean, default: false
  field :user_id, type: Integer
  field :approved, type: Boolean, default: false

  attr_accessible :approved, :ship, :start_date, :end_date, :captain, :primary_observer, :chief_scientist, :objective, :archived, :user_id, :cruise_name

  validates_presence_of :ship, :start_date, :end_date, :primary_observer, :objective, :cruise_name
  validates_length_of :objective, {maximum: 300}
  
  
  has_many :observations, order: 'obs_datetime DESC'  do
    def recent count
      desc(:obs_datetime).limit(count)
    end
  end
  has_many :photos
   
  belongs_to :user
  has_many :uploaded_observations
  
  scope :active, ->(){where(:start_date.lte => Time.zone.now).where(:end_date.gte => Time.zone.now)}
  scope :archived, ->(){where(:archived => true)}
  scope :upcoming, ->(){where(:start_date.gte => Time.zone.now)}
  scope :ended, ->(){where(:end_date.lte => Time.zone.now)}
  scope :year, ->(year){between(start_date: [year,year.end_of_year]).or.between(end_date: [year,year.end_of_year])}
  
  default_scope ->{where(approved: true).asc(:start_date)}
  
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
    #observation = self.observations.where(accepted:true).last
    return nil if self.observations.empty? 
    coordinates = self.observations.collect{|obs| [obs.try(:longitude), obs.try(:latitude)]}
    [{
      type: "Feature",
      geometry: {
        type: "LineString",
        coordinates: coordinates
      },
      properties: {
        cruise_id: self.id
      }     
    },{
      type: "Feature",
      geometry: {
        type: "MultiPoint",
        coordinates: coordinates
      },      
      properties: {
        cruise_id: self.id
      } 
    }]  
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
