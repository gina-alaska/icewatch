class BiotaLocationLookup
  include Mongoid::Document
  field :name, type: String
  field :code, type: Integer
end
