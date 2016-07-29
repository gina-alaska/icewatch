module Importable
  module Photo
    extend ActiveSupport::Concern

    ASSIGNABLE_ATTRIBUTES = %w( on_boat_location_lookup_code note checksum file_filename ).freeze

    def from_export(json)
      obs_data = json.dup
      obs_data['file_filename'] = obs_data.delete('name') if obs_data.key?('name')

      assign_attributes(obs_data.select { |k, _v| ASSIGNABLE_ATTRIBUTES.include?(k) })
    end
  end
end
