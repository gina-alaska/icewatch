module Importable
  module Observation
    extend ActiveSupport::Concern

    ASSIGNABLE_ATTRIBUTES = %w( observed_at latitude longitude uuid
                                primary_observer_id_or_name
                                additional_observers_id_or_name).freeze

    ASSIGNABLE_MODELS = %w( ice ice_observations meteorology notes comments ship photos).freeze

    def from_export(json)
      obs_data = json.dup

      rewrite_legacy_observed_at(obs_data)
      rewrite_observers(obs_data, 'primary_observer')
      rewrite_observers(obs_data, 'additional_observers')

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

      self
    end

    def rewrite_legacy_observed_at(json)
      json['observed_at'] = json.delete('obs_datetime') if json.key?('obs_datetime')
    end

    def rewrite_observers(json, key)
      json["#{key}_id_or_name"] = json.delete(key) if json.key?(key)
    end
  end
end
