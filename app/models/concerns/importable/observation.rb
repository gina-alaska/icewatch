module Importable
  module Observation

    extend ActiveSupport::Concern

    ASSIGNABLE_ATTRIBUTES = %w( observed_at latitude longitude uuid )
    ASSIGNABLE_MODELS = %w(ice ice_observations )


    def from_json(json)
      obs_data = json.dup

      rewrite_legacy_observed_at(json)

      assign_attributes(json.values_at(ASSIGNABLE_ATTRIBUTES)

      ASSIGNABLE_MODELS.each do |model|
        if json.has_key?(model)
          self.send(model).build.from_json(json[model])
        end
      end

    end

    def rewrite_legacy_observed_at(json)
      json['observed_at'] = json.delete('obs_datetime') if json.has_key?('obs_datetime')
    end

    def rewrite_observers(json, key)
      person = json.delete(key)
      json["#{key}_id_or_name"] = fix_observer(person)
    end

    def fix_observer person
      return nil unless person.present?
      case
      when person.is_a?(Array)
        person.map{|j| fix_observer(j)}.flatten
      when person.is_a?(Hash)
        Person.where(name: "#{person['firstname']} #{person['lastname']}").first.try(:name) || person
      else
        Person.where(name: person).first.try(:name) || person
      end
    end
  end
end