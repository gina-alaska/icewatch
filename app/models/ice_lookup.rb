class IceLookup
  include Mongoid::Document
  include AssistShared::Concerns::IceType

  field :code, type: Integer
  field :name, type: String

  scope :ice_type, ->(type){ self.in(code: "IceLookup::#{type.upcase}_ICE".constantize)}
end
