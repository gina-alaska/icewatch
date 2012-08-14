class Observation
  include Mongoid::Document
  include AssistShared::Validations::Observation
  
  validates_presence_of :cruise_id
  validates_uniqueness_of :hexcode
  
  field :obs_datetime, type: Time
  field :accepted, type: Boolean, default: false
  field :is_valid, type: Boolean, default: false
  field :hexcode, type: String
  
  embeds_one :ice
  embeds_one :meteorology
  embeds_many :ice_observations
  embeds_many :photos
  embeds_many :comments
  
  belongs_to :cruise

  accepts_nested_attributes_for :ice, :ice_observations, :meteorology, :photos, :comments
  
  default_scope desc(:obs_datetime)
  
  scope :has_errors, where(:is_valid => false)
  scope :pending, where(:accepted => false)
  
  
  
  def as_geojson opts={}
    data = self.as_json
    data.delete(:latitude) if data[:latitude]
    data.delete(:longitude) if data[:longitude]
    data[:location] = {
      type: "Feature",
      geometry: {
        type: "Point",
        coordinates: [self.longitude, self.latitude]
      }
    }
    
    data
  end

  # def as_json *opts
  #   # data = super
  #   # lat = data.delete(:latitude)
  #   # lon = data.delete(:longitude)
  #   # data[:location] = {
  #   #   type: "Feature",
  #   #   geometry: {
  #   #     type: "Point",
  #   #     coordinates: [self.longitude, self.latitude]
  #   #   }
  #   # }
  #   # data
  # end
  
  
  def self.from_file file, params={}
    case params[:content_type]
    when "application/zip"
      self.from_zip file, params
    when "application/json"
      data = JSON.parse(File.read(file))
      self.from_json data, params
    when "text/csv"
      self.from_csv
    else
      
    end
      
  end
  
  def self.from_zip file, params={}
    obs = []
    Zip::ZipFile.open(file) do |z|
      if(z.file.exists?("METADATA"))
        md = YAML.load((z.file.read("METADATA")))
        file = md[:assist_version] == "1.0" ? "aorlich_summer_2012.observations.json" : md[:observations]
      elsif(z.file.exists?("observation.json"))
        file = "observation.json"
      end
      data = ::JSON.parse(z.file.read(file))
      obs = self.from_json(data, params)
    end
    obs
  end
  
  def self.from_json data, params={}
    observations = []
    data.each do |obs|
      obs = JSON.parse(obs)
      obs.merge!(params[:observation]) if params[:observation]
      o = Observation.new(obs)
      o.is_valid = o.valid?
      unless o.valid?
        logger.info o.errors
      end
      o.save validate: false
      observations << o
    end
    observations
  end
  
  def self.from_csv
  end
    
end
