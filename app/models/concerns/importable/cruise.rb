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

      # unique_fields = %w(latitude longitude observed_at)

      # new_observation = observations.where()

      new_observation = observations.build.from_export(obs_data)
      new_observation.save(validate: false)
      new_observation.reload

      new_observation.destroy unless new_observation.valid?
    end
  end
end
