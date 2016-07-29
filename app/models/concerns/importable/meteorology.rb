module Importable
  module Meteorology
    extend ActiveSupport::Concern

    ASSIGNABLE_ATTRIBUTES = %w( air_pressure air_temperature relative_humidity
                                total_cloud_cover visibility_lookup_code
                                water_temperature weather_lookup_code
                                wind_direction wind_speed ).freeze

    ASSIGNABLE_MODELS = %w( clouds ).freeze

    def from_export(json)
      obs_data = json.dup

      assign_attributes(obs_data.select { |k, _v| ASSIGNABLE_ATTRIBUTES.include?(k) })

      ASSIGNABLE_MODELS.each do |model|
        next unless obs_data.key?(model)

        case
        when obs_data[model].is_a?(Hash)
          send("build_#{model}").from_export(obs_data[model])
        when obs_data[model].is_a?(Array)
          obs_data[model].each do |m|
            send(model).build.from_export(m)
          end
        end
      end
    end
  end
end
