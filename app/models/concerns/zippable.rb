module Zippable
  extend ActiveSupport::Concern

  def zip!(renderable_obs, include_photos = false)
    create_export_path!
    remove_existing_export!

    Zip::File.open(export_filepath, Zip::File::CREATE) do |zipfile|
      zipfile.get_output_stream("METADATA") { |f| f << metadata.to_yaml }

      zipfile.get_output_stream("#{self}.json") do |f|
        f << JSON.pretty_generate(JSON.parse(render_to_string(renderable_obs)))
      end

      zipfile.get_output_stream("#{self}.csv") do |f|
        f << Observation.csv_headers + "\n"
        renderable_obs.each do |o|
          f << o.as_csv.to_csv
        end
      end
      
      if include_photos
        renderable_obs.each do |observation|
          observation.photos.each do |photo|
            zipfile.get_output_stream(photo.observation_filepath) do |f|
              f << photo.file.read
            end
          end
        end
      end
    end

    export_filepath
  end

  private

  def create_export_path!
    FileUtils.mkdir_p export_path unless File.exist? export_path
  end

  def remove_existing_export!
    FileUtils.remove(export_filepath) if File.exist?(export_filepath)
  end

  def export_filepath
    @export_filepath ||= File.join(export_path, "#{self}.zip")
  end
end
