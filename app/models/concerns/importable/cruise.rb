module Importable
  module Cruise
    extend ActiveSupport::Concern

    def observations_from_export(cruise_json)
      return unless cruise_json.key?('observations')

      cruise_data = cruise_json.dup

      cruise_data['observations'].each do |obs_json|
        observation_from_export(obs_json)
      end
    end

    def observation_from_export(json)
      obs_data = json.dup

      existing = observations.where(latitude: obs_data['latitude'],
                                    longitude: obs_data['longitude'],
                                    observed_at: obs_data['observed_at'] || obs_data['obs_datetime'])
      existing.destroy_all


      new_observation = observations.build.from_export(obs_data)
      new_observation.save(validate: false)
    end
  end
end
