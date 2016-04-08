module Importable
  module Ice
    extend ActiveSupport::Concern

    ASSIGNABLE_ATTRIBUTES = %w( open_water_lookup_code thick_ice_lookup_code
                                thin_ice_lookup_code total_concentration ).freeze

    def from_export(json)
      obs_data = json.dup

      assign_attributes(obs_data.select { |k, _v| ASSIGNABLE_ATTRIBUTES.include?(k) })
    end
  end
end
