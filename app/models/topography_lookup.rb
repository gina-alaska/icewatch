class TopographyLookup < Lookup
  scope :codes_between, -> (low, high) { where(code: (low..high).map(&:to_s)) }
end
