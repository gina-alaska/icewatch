class SurfaceLookup
  include Mongoid::Document

  field :code, type: Integer
  field :name, type: String
end
