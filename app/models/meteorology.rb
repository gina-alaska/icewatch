class Meteorology < ActiveRecord::Base
  has_one :high_cloud, class_name: 'Cloud'
  has_one :medium_cloud, class_name: 'Cloud'
  has_one :low_cloud, class_name: 'Cloud'
  has_many :clouds

  belongs_to :weather_lookup
  belongs_to :visibility_lookup

  accepts_nested_attributes_for :clouds
end
