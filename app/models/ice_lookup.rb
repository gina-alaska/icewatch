class IceLookup
  include Mongoid::Document
  include Mongoid::Versioning

  field :code, type: Integer
  field :name, type: String
  
  NEW_ICE = 0..59
  FIRST_YEAR_ICE = 60..74
  OLD_ICE = 75..100
end
