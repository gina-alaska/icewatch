class IceLookup
  include Mongoid::Document
  include AssistShared::Concerns::IceType

  field :code, type: Integer
  field :name, type: String

  scope :ice_type, ->(type){ self.in(code: self.const_get("#{type.upcase}_ICE"))}

end
