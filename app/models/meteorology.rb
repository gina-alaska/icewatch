class Meteorology < ActiveRecord::Base
  has_many :clouds

  has_one :high_cloud, -> { high }, class_name: 'Cloud'
  has_one :medium_cloud, -> { medium }, class_name: 'Cloud'
  has_one :low_cloud, -> { low }, class_name: 'Cloud'

  belongs_to :weather_lookup
  belongs_to :visibility_lookup
  belongs_to :observation

  accepts_nested_attributes_for :clouds, :high_cloud, :medium_cloud, :low_cloud

  validates :visibility_lookup_id, presence: true
  validates_with Validations::LookupCodeValidator,
                 fields: {
                   visibility_lookup_id: 'visibility_lookup',
                   weather_lookup_id: 'weather_lookup'
                 }, allow_blank: true

  validates :total_cloud_cover,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 8
            },
            allow_blank: true
  validates :wind_speed, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :wind_direction,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 360
            },
            allow_blank: true
  validates :air_temperature, numericality: true, allow_blank: true
  validates :water_temperature, numericality: true, allow_blank: true
  validates :relative_humidity,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 100
            },
            allow_blank: true
  validates :relative_humidity, numericality: true, allow_blank: true

  def as_csv
    [
      weather_lookup.try(:code),
      visibility_lookup.try(:code),
      high_cloud.as_csv,
      medium_cloud.as_csv,
      low_cloud.as_csv,
      total_cloud_cover,
      wind_speed,
      wind_direction,
      air_temperature,
      water_temperature,
      relative_humidity,
      air_pressure
    ]
  end

  %w(visibility weather).each do |lookup|
    define_method "#{lookup}_lookup_code" do      # define_method "weather_lookup_code" do
      send("#{lookup}_lookup").try(&:code)    #   self.send("weather_lookup_code").try(&:code)
    end                                           # end
  end
end
