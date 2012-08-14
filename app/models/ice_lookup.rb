class IceLookup
  include Mongoid::Document
  include Mongoid::Versioning

  field :code, type: Integer
  field :name, type: String
end
