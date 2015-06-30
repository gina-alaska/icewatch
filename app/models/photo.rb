class Photo < ActiveRecord::Base
  belongs_to :observation
  belongs_to :on_boat_location_lookup

  validates_presence_of :name
  validates_uniqueness_of :checksum, scope: [:observation_id], message: 'This photo has already been attached to this report'

  before_save :copy_file, prepend: true, if: -> (photo) { photo.tempfile.present? }
  before_save :generate_checksum, if: -> (photo) { photo.name.present? && File.exist?(file_path) }
  before_destroy :remove_image_file

  attr_accessor :tempfile

  def copy_file
    self.name = tempfile.original_filename
    FileUtils.mkdir_p(File.dirname(file_path))
    File.open(file_path, 'wb') do |file|
      tempfile.rewind
      file.write(tempfile.read)
    end
  end

  def generate_checksum
    self.checksum = Digest::MD5.hexdigest(File.read(file_path))
  end

  def remove_image_file
    # Shouldn't allow duplicate uploads, but for now don't remove it if another image is using it
    if observation.photos.where(name: name).count <= 1
      FileUtils.remove(file_path) if File.exist?(file_path)
    end
  end

  def file_path
    File.join(observation.export_path, name)
  end

  def url
    File.join(observation.relative_export_path, name).gsub(/public\//, '')
  end

  def on_boat_location_lookup_code
    on_boat_location_lookup.try(:code)
  end
end
