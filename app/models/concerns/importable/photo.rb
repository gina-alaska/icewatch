module Importable
  module Photo
    extend ActiveSupport::Concern

    ASSIGNABLE_ATTRIBUTES = %w( on_boat_location_lookup_code note checksum name )


    def from_export(json)
      obs_data = json.dup

      assign_attributes(obs_data.select{|k,v| ASSIGNABLE_ATTRIBUTES.include?(k) })
    end
  end
end