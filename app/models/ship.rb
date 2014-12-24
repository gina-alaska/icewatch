class Ship < ActiveRecord::Base
  POWER_VALUES = %w{0 1/4 1/2 3/4 full}
  validates :power,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 4
    },
    allow_blank: true
  validates :heading,
    numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 360},
    allow_blank: true

end
