module Importable
  module MeltPond
    extend ActiveSupport::Concern

    ASSIGNABLE_ATTRIBUTES = %w( bottom_type_lookup_code dried_ice freeboard
                                max_depth_lookup_code pattern_lookup_code
                                rotten_ice surface_coverage surface_lookup_code )


    def from_export(json)
      obs_data = json.dup

      assign_attributes(obs_data.select{|k,v| ASSIGNABLE_ATTRIBUTES.include?(k) })
    end
  end
end