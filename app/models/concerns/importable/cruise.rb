module Importable
  module Cruise
    extend ActiveSupport::Concern

    def observations_from_export(cruise_json)
      return unless cruise_json.has_key?('observations')

      cruise_data = cruise_json.dup

      cruise_data['observations'].each_with_index do |obs_json, idx|
        observation_from_export(obs_json)
      end
    end

    def observation_from_export(json)
      obs_data = json.dup

      new_observation = observations.build.from_export(obs_data)
      new_observation.save(validate: false)
      new_observation.reload

      unless new_observation.valid?
        new_observation.destroy
      end
    end
  end
end