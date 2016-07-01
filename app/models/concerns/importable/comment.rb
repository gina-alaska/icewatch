module Importable
  module Comment
    extend ActiveSupport::Concern

    ASSIGNABLE_ATTRIBUTES = %w( text ).freeze

    def from_export(json)
      return if json.nil?
      obs_data = json.dup

      case
      when obs_data.is_a?(String)
        self.text = obs_data
      when obs_data.is_a?(Hash)
        assign_attributes(obs_data.select { |k, _v| ASSIGNABLE_ATTRIBUTES.include?(k) })
        if obs_data.key?("person")
          self.person = Person.where(name: obs_data['person']).first_or_initialize
        end
      end
    end
  end
end
