class Meteorology
  include Mongoid::Document
  include AssistShared::Validations::Meteorology
  include AssistShared::CSV::Meteorology


  embedded_in :observation
  
  embeds_many :clouds do 
    def cloud_type type
      where(cloud_type: type).first
    end
    def high
      cloud_type 'high'
    end
    def medium
      cloud_type 'medium'
    end
    def low
      cloud_type 'low'
    end
  end
  accepts_nested_attributes_for :clouds

  belongs_to :weather_lookup
  belongs_to :visibility_lookup

  field :total_cloud_cover, type: Integer
  field :wind_speed, type: Integer
  field :wind_direction, type: String
  field :air_temperature, type: Integer
  field :water_temperature, type: Integer
  field :relative_humidity, type: Integer
  field :air_pressure, type: Integer
  
  before_validation do |met|
    %w(high medium low).each do |cloud_type|
      if(met.clouds.cloud_type(cloud_type).nil?)
        met.clouds << Cloud.new(cloud_type: cloud_type)
      end
    end
  end
  
  
end