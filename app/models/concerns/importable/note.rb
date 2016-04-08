module Importable
  module Note
    extend ActiveSupport::Concern

    ASSIGNABLE_ATTRIBUTES = %w( text ).freeze

    def from_export(json)
      obs_data = json.dup unless json.nil?
      obs_data ||= ""

      case
      when obs_data.is_a?(String)
        self.text = obs_data
      when obs_data.is_a?(Hash)
        assign_attributes(obs_data.select { |k, _v| ASSIGNABLE_ATTRIBUTES.include?(k) })
      end
    end
  end
end
