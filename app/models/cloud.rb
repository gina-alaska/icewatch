class Cloud < ActiveRecord::Base
  belongs_to :meteorology
  belongs_to :cloud_lookup

  scope :high, -> { where(cloud_type: 'high') }
  scope :medium, -> { where(cloud_type: 'medium') }
  scope :low, -> { where(cloud_type: 'low') }

  validates_uniqueness_of :cloud_type, scope: :meteorology_id
  validates :cover, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :height, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :cloud_type, inclusion: { in: %w(low medium high) }

  CLOUD_COVER_VALUES = (0..8).to_a

  def as_csv
    [cloud_lookup.try(:code), cover, height]
  end

  def cloud_lookup_code
    cloud_lookup.try(&:code)
  end
end
