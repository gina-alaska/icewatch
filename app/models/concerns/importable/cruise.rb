module Importable
  module Cruise
    extend ActiveSupport::Concern

    def observations_from_export(cruise_json)
      return unless cruise_json.key?('observations') || cruise_json.key?('observed_at') || cruise_json.key?('obs_datetime')

      cruise_data = cruise_json.dup

      import_cruise_observations if cruise_data['observations'].present?
      observation_from_export(cruise_data) if cruise_data['observed_at'].present?
      observation_from_export(cruise_data) if cruise_data['obs_datetime'].present?
    end

    def import_cruise_observations(cruise_json)
      cruise_json['observations'].each do |obs_json|
        observation_from_export(obs_json)
      end
    end

    def observation_from_export(json)
      obs_data = json.dup
      new_observation = observations.where(latitude: obs_data['latitude'],
                                           longitude: obs_data['longitude'],
                                           observed_at: obs_data['observed_at'] || obs_data['obs_datetime'])
      new_observation = new_observation.first_or_initialize

      new_observation.from_export(obs_data)
      new_observation.save(validate: false)
    end
  end
end
