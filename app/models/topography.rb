class Topography < ActiveRecord::Base
  belongs_to :ice_observation
  belongs_to :topography_lookup

  validates :concentration, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 10
    },
    allow_blank: true
  validates :ridge_height, numericality: {
      greater_than_or_equal_to: 0
    },
    allow_blank: true

  validates_with Validations::LookupCodeValidator, fields: {
    topography_lookup: 'topography_lookup'
    },
    allow_blank: true

  def as_csv
    [
      topography_lookup.try(:code),
      concentration,
      ridge_height,
      old,
      consolidated,
      snow_covered
    ]
  end

  def topography_lookup_code
    topography_lookup.try(&:code)
  end
end
