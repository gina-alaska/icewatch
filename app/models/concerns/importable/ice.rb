module Importable
  module Ice
    extend ActiveSupport::Concern

    ASSIGNABLE_ATTRIBUTES = %w( open_water_lookup_code thick_ice_lookup_code
                                thin_ice_lookup_code total_concentration )


    def from_export(json)
      obs_data = json.dup

      assign_attributes(obs_data.select{|k,v| ASSIGNABLE_ATTRIBUTES.include?(k) })
    end
  end
end