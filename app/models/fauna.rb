class Fauna < ActiveRecord::Base
  belongs_to :observation

  validates :count,  numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
