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
  embeds_one :additional_data
  
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
    errors.add(:cruise_id, "Cruise ID's do not match") if self.attributes.has_key? "imported_as_cruise_id"
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
      
end
