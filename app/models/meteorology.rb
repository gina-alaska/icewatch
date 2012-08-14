class Meteorology
  include Mongoid::Document
  include AssistShared::Validations::Meteorology

  embedded_in :observation
  
  field :weather_lookup_code, type:Integer
  field :visibility_lookup_code, type:Integer
end