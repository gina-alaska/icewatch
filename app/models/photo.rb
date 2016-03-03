class Photo < ActiveRecord::Base
  belongs_to :photoable, polymorphic: true
  belongs_to :on_boat_location_lookup

  attachment :file, type: :image

  before_save :generate_checksum, unless: -> (photo) { photo.file.nil? }

  def generate_checksum
    self.checksum = Digest::MD5.hexdigest(File.read(file.download))
  end

  def on_boat_location_lookup_code
    on_boat_location_lookup.try(:code)
  end
end
