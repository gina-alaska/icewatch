class CloudLookup
  include Mongoid::Document
  include Mongoid::Versioning
  
  field :code, type: String 
  field :name, type: String
end
