module Importable::Cruise
  extend ActiveSupport::Concern

  def observations_from_json(cruise_json)
    return unless cruise_json.has_key?('observations')

    cruise_json['observations'].each do |obs_json|
      observation_from_json(obs_json)
    end
  end

  def observation_from_json(obs_json)
    json = obs_json.dup

    rewrite(json)


    new_observation = observations.build
    new_observation.assign_attributes(json)

    puts JSON.pretty_generate(json)
    puts new_observation.photos.inspect

    new_observation.save(validate: false)

    unless new_observation.valid?
      new_observation.destroy
    end
  end

  def rewrite(json)
    rewrite_legacy_observed_at(json)
    rewrite_observers(json, 'primary_observer')
    rewrite_observers(json, 'additional_observers')
    rewrite_notes(json)
    rewrite_comments(json)
    rewrite_related_attributes(json, Observation)
    rewrite_lookup_codes(json)
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

  def rewrite_related_attributes(json, model)
    case
    when json.is_a?(Array)
      json.each { |item| rewrite_related_attributes(item, model) }
    when json.is_a?(Hash)
      model._reflections.keys.each do |key|
        if json.has_key?(key)
          rewrite_related_attributes(json[key], key.to_s.singularize.camelize.constantize)
          json["#{key}_attributes"] = json.delete(key)
        end
      end
    end

  end

  def rewrite_lookup_codes(json)
    return unless json.respond_to?(:keys)
    json.keys.each do |k|
      case
      when k =~ /lookup_code/
        code = json.delete(k)
        key = k.gsub(/biota/, 'algae')
        table_name = key.chomp('_code').camelcase
        table = table_name.gsub(/^(Thick|Thin)/, '').constantize
        json[key.gsub(/_code/, '_id')] = table.where(code: code.to_s).first.try(:id)
      when json[k].is_a?(Array)
        json[k].each { |val| rewrite_lookup_codes(val) }
      when json[k].is_a?(Hash)
        rewrite_lookup_codes json[k]
      end
    end
  end

  def rewrite_notes(json)
    json['notes'] = json['notes'].map{ |n| { text: n } }
  end

  def rewrite_comments(json)
    json['comments'] = json['comments'].map{ |c| { text: c } }
  end
end