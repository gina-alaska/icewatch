class Photo < ActiveRecord::Base
  belongs_to :observation
  belongs_to :cruise
  belongs_to :on_boat_location_lookup

  attachment :file, type: :image

  before_save :generate_checksum, unless: -> (photo) { photo.file.nil? }
  before_save :associate_with_cruise, unless: -> (photo) { photo.observation.nil? }

  def generate_checksum
    self.checksum = Digest::MD5.hexdigest(File.read(file.download))
  end

  def on_boat_location_lookup_code
    on_boat_location_lookup.try(:code)
  end

  def associate_with_cruise
    self.cruise_id = observation.cruise_id
  end
end
