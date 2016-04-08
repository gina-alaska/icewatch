module Importable
  module IceObservation
    extend ActiveSupport::Concern

    ASSIGNABLE_ATTRIBUTES = %w( obs_type
                                partial_concentration
                                algae_density_lookup_code
                                algae_location_lookup_code
                                floe_size_lookup_code
                                ice_lookup_code
                                sediment_lookup_code
                                snow_lookup_code
                                thickness
                                ).freeze

    ASSIGNABLE_MODELS = %w( topography melt_pond ).freeze

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
