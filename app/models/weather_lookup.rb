class WeatherLookup
  include Mongoid::Document

field :code, type: Integer
  field :name, type: String
end
