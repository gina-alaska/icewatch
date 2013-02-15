class Observation
  include Mongoid::Document
  include AssistShared::Validations::Observation
  include AssistShared::CSV::Observation
  
  before_validation :check_imported_as_cruise_id
  
  before_create do |obs|
    begin
      obs.uuid = SecureRandom.uuid
    end while Observation.where(uuid: obs.uuid).any?
    
    if obs.primary_observer.unknown?
      obs.primary_observer = Person.new(firstname: "Unknown", lastname: "Observer")
    end
  end
  
  validates_presence_of :cruise_id
  validate :absence_of_imported_as_cruise_id
  
  field :obs_datetime, type: Time
  field :accepted, type: Boolean, default: false
  field :is_valid, type: Boolean, default: false
  field :hexcode, type: String
  field :latitude, type: Float
  field :longitude, type: Float
  field :uuid, type: String
  
  embeds_one :primary_observer, class_name: "Person"
  embeds_many :additional_observers, class_name: "Person"
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
    
    def ice_type range
      self.in(ice_lookup_id: IceLookup.in(code: range).collect(&:id))
    end
    
    def new_ice
      ice_type IceLookup::NEW_ICE
    end
    def first_year_ice
      ice_type IceLookup::FIRST_YEAR_ICE
    end
    def old_ice
      ice_type IceLookup::OLD_ICE
    end
    def other_ice
      ice_type IceLookup::OTHER 
    end

  end
  
  embeds_many :photos
  embeds_many :comments
  embeds_one :additional_data
  
  belongs_to :cruise

  accepts_nested_attributes_for :ice, :ice_observations, :meteorology, :photos, :comments
  
  default_scope asc(:obs_datetime).where(accepted: true )
  
  scope :has_errors, where(:is_valid => false)
  scope :pending, where(:accepted => false)
  

  def as_geojson opts={}
    {
      type: "Feature",
      geometry: {
        type: "Point",
        coordinates: [self.longitude, self.latitude]
      },
      properties: {
        new_ice_concentration: self.new_ice_concentration * 10,
        old_ice_concentration: self.old_ice_concentration * 10,
        first_year_ice_concentration: self.first_year_ice_concentration * 10,
        total_concentration: self.ice.total_concentration,
        color: self.concentration_color,
        dominant_ice_type: self.dominant_ice_type.to_s
      }
    }
  end

  def as_json opts={}
    data = super except: [:_id, :hexcode, :accepted, :cruise_id, :is_valid]
    
    data = lookup_id_to_code(data)
    data
  end

  def check_imported_as_cruise_id
    if self.attributes.has_key? "imported_as_cruise_id"
      self.attributes.delete("imported_as_cruise_id") if self.attributes["imported_as_cruise_id"] == self.cruise_id.to_s
    end
  end
  
  def absence_of_imported_as_cruise_id
    errors.add(:base, "Cruise ID's do not match") if self.attributes.has_key? "imported_as_cruise_id"
  end

  def lookup_id_to_code(hash) 
    hash.inject(Hash.new) do |h, (k,v)|
      key = k.gsub(/lookup_id$/, "lookup_code")

      case v.class.to_s
      when "Hash"
        h[key] = lookup_id_to_code(v)
      when "Array"
        h[key] = v.collect{|item| item.is_a?(Hash) ? lookup_id_to_code(item) : item } 
      else
        if(key =~ /lookup_code$/ and !!v)
          table = key.gsub(/^thi(n|ck)_ice_lookup/,"ice_lookup")
          logger.info(table)
          #Use where instead of find. If any bad values got injected it will turn them into nil
          v = table.chomp("_code").camelcase.constantize.where(id: v).first.try(&:code)
        end
        h[key] = v
      end
      h
    end
  end 
  
  def concentrations 
    { 
      old: self.old_ice_concentration,
      new: self.new_ice_concentration,
      first_year: self.first_year_ice_concentration,
      other: self.other_ice_concentration
    }
  end
  
  def concentration type
    type.inject(0){|sum,v| sum + v.partial_concentration.to_i}
  end
  def new_ice_concentration
    concentration(ice_observations.new_ice)
  end
  def old_ice_concentration
    concentration(ice_observations.old_ice)
  end
  def first_year_ice_concentration
    concentration(ice_observations.first_year_ice)
  end
  def other_ice_concentration
    concentration(ice_observations.other_ice)
  end
  
  def dominant_ice_type
    concentrations.max{|a,b| a[1] <=> b[1] }.first
  end
   
  def concentration_color
    case dominant_ice_type
    when :old
      "#50BBD4"
    when :new
      "#D9D9D9"
    when :first_year 
      "#BFD7D3"     
    end
  end      
end
