module Importable
  module Meteorology
    extend ActiveSupport::Concern

    ASSIGNABLE_ATTRIBUTES = %w( air_pressure air_temperature relative_humidity
                                total_cloud_cover visibility_lookup_code
                                water_temperature weather_lookup_code
                                wind_direction wind_speed )

    ASSIGNABLE_MODELS = %w( clouds )

    def from_export(json)
      obs_data = json.dup

      assign_attributes(obs_data.select{|k,v| ASSIGNABLE_ATTRIBUTES.include?(k) })

      ASSIGNABLE_MODELS.each do |model|
        if obs_data.has_key?(model)
          case
          when obs_data[model].is_a?(Hash)
            self.send("build_#{model}").from_export(obs_data[model])
          when obs_data[model].is_a?(Array)
            obs_data[model].each do |m|
              self.send(model).build.from_export(m)
            end
          end
        end
      end
    end
  end
end