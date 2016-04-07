module Importable
  module Cloud
    extend ActiveSupport::Concern

    ASSIGNABLE_ATTRIBUTES = %w( cloud_type cloud_lookup_code cover height )


    def from_export(json)
      obs_data = json.dup

      assign_attributes(obs_data.select{|k,v| ASSIGNABLE_ATTRIBUTES.include?(k) })
    end
  end
end