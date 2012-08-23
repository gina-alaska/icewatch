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
  
  
end