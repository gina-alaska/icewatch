class Fauna
  include Mongoid::Document
  field :name, type: String
  field :count, type: Integer
  
  embedded_in :observation
end
