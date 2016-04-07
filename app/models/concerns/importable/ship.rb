module Importable
  module Ship
    extend ActiveSupport::Concern

    ASSIGNABLE_ATTRIBUTES = %w( heading power ship_activity_lookup_code speed )


    def from_export(json)
      obs_data = json.dup

      assign_attributes(obs_data.select{|k,v| ASSIGNABLE_ATTRIBUTES.include?(k) })
    end
  end
end