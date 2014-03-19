class IceLookup
  include Mongoid::Document

  field :code, type: Integer
  field :name, type: String

  NEW_ICE = [10,11,12,20,30,40,50]
  FIRST_YEAR_ICE = [60,70,80]
  OLD_ICE = [75,85]
  OTHER = (0..100).to_a - [NEW_ICE, FIRST_YEAR_ICE, OLD_ICE].flatten
  ORDERED_CODES = [NEW_ICE, FIRST_YEAR_ICE, OLD_ICE, OTHER].flatten

  scope :ice_type, ->(type){ self.in(code: "IceLookup::#{type.upcase}_ICE".constantize)}
end
