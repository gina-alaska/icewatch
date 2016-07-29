module Exportable
  extend ActiveSupport::Concern

  included do
    after_commit :write_data, if: -> { Icewatch.assist? }
    before_destroy :delete_data, if: -> { Icewatch.assist? }
  end

  def write_data
    return if !valid?
    create_export_directory!
    create_photo_export_directory!
    export_json
    export_photos
    remove_deleted_photos
    remove_renamed_obs
  end

  def create_export_directory!
    FileUtils.mkdir_p(export_path) unless File.exist?(export_path)
  end

  def create_photo_export_directory!
    FileUtils.mkdir_p(photo_export_path) unless File.exist?(photo_export_path)
  end

  def photo_export_path
    File.join(export_path, 'photos')
  end

  def export_json
    File.open(File.join(export_path, "#{to_s}.json"), 'w') do |f|
      f << JSON.pretty_generate(JSON.parse(render_to_string))
    end
  end

  def export_csv
    File.open(File.join(export_path, "#{to_s}.csv"), 'w') do |f|
      f << Observation.csv_headers
      f << as_csv.to_csv.html_safe
    end
  end

  def export_photos
    photos.each do |photo|
      photo_export_filepath = File.join(photo_export_path, photo.file_filename)
      return if File.exists?(photo_export_filepath)
      File.open(photo_export_filepath, 'wb') do |f|
        f << photo.file.to_io.read
      end
    end
  end

  def remove_deleted_photos
    photo_files = Dir.glob(File.join(photo_export_path, '*')).map{ |f| File.basename(f) }
    (photo_files - photos.pluck(:file_filename)).each do |photo|
      FileUtils.remove_entry_secure(File.join(photo_export_path,photo))
    end
  end

  def remove_renamed_obs
    exported_obs = Dir.glob(File.join(cruise.export_path, '*')).map{ |f| File.basename(f) }

    (exported_obs - cruise.observations.map(&:to_s)).each do |invalid_obs|
      FileUtils.remove_entry_secure(File.join(cruise.export_path, invalid_obs))
    end
  end

  def delete_data
    FileUtils.remove_entry_secure(export_path)
  end
end