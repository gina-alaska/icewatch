module Importable
  module Note
    extend ActiveSupport::Concern

    ASSIGNABLE_ATTRIBUTES = %w( text )


    def from_export(json)
      obs_data = json.dup unless json.nil?
      obs_data ||= ""

      case
      when obs_data.is_a?(String)
        text = obs_data
      when obs_data.is_a?(Hash)
        assign_attributes(obs_data.select{|k,v| ASSIGNABLE_ATTRIBUTES.include?(k) })
      end
    end
  end
end