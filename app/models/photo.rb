class Photo < ActiveRecord::Base
  include Lookupable
  belongs_to :observation
  belongs_to :cruise

  lookup :on_boat_location_lookup

  attachment :file, type: :image

  before_save :generate_checksum, unless: -> (photo) { photo.file.nil? }
  before_save :associate_with_cruise, unless: -> (photo) { photo.observation.nil? }

  def generate_checksum
    self.checksum = Digest::MD5.hexdigest(File.read(file.download))
  end

  def associate_with_cruise
    self.cruise_id = observation.cruise_id
  end

  def observation_filepath
    File.join(observation.to_s, file_filename)
  end
end
