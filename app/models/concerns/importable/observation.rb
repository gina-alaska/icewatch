module Importable
  module Observation

    extend ActiveSupport::Concern

    ASSIGNABLE_ATTRIBUTES = %w( observed_at latitude longitude uuid
                                primary_observer_id_or_name
                                additional_observers_id_or_name)

    ASSIGNABLE_MODELS = %w( ice ice_observations meteorology notes comments ship photos)


    def from_export(json)
      obs_data = json.dup

      rewrite_legacy_observed_at(obs_data)
      rewrite_observers(obs_data, 'primary_observer')
      rewrite_observers(obs_data, 'additional_observers')

      assign_attributes(obs_data.select{|k,v| ASSIGNABLE_ATTRIBUTES.include?(k) })

      ASSIGNABLE_MODELS.each do |model|
        if obs_data.has_key?(model)
          case
          when obs_data[model].is_a?(Hash)
            self.send("build_#{model}").from_export(obs_data[model])
          when obs_data[model].is_a?(Array)
            obs_data[model].each do |m|
              self.send(model).build.from_export(m)
            end
          end
        end
      end

      self
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