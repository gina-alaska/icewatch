module IceTypes
  NEW_ICE = [10, 11, 12, 20, 30, 40, 50].freeze
  FIRST_YEAR_ICE = [60, 70, 80].freeze
  OLD_ICE = [75, 85].freeze
  OTHER = ((0..100).to_a - [NEW_ICE, FIRST_YEAR_ICE, OLD_ICE].flatten + [nil]).freeze
  ORDERED_CODES = [NEW_ICE, FIRST_YEAR_ICE, OLD_ICE, OTHER].flatten.freeze
end
