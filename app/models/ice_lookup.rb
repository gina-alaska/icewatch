class IceLookup < Lookup
  include IceTypes

  has_many :ice_observations
  has_many :ices

  scope :ice_type, ->(codes) { where(code: Array(codes).map(&:to_s)) }
end
