namespace :import do
  namespace :legacy do
    desc "Import cruises from the live site"
    task :cruises => :environment do
      require 'httparty'

      response = HTTParty.get('http://icewatch.gina.alaska.edu/api/cruises.json')
      cruises = JSON.parse(response.body)

      cruises.each do |original|
        observations = original['observations']
        original_id = original['_id']

        c = Cruise.first_or_create cruise_params(original)
        observations.each do |observation|
          o = c.observations.where(uuid: observation['uuid']).first_or_initialize(observation_attributes(observation))
          # o.update_attributes(observation_attributes(observation))
          o.save(validate:false)
        end
      end

    end

    def cruise_params(cruise)
      valid_keys = %w{
        approved captain
        chief_scientist name end_date
        start_date objective primary_observer
        ship
      }
      cruise.keep_if{|k,v| valid_keys.include?(k.to_s) }
      cruise['starts_at'] = cruise.delete('start_date')
      cruise['ends_at'] = cruise.delete('end_date')
      cruise
    end

    def observation_attributes(observation)
      observation['observed_at'] = observation.delete('obs_datetime')
      %w{ship ice meteorology notes ice_observations primary_observer additional_observers}.each do |attr|
        observation["#{attr}_attributes"] = observation.delete(attr) if observation.has_key? attr
      end

      observation['primary_observer_attributes'] = fix_name(observation['primary_observer_attributes'])

      observation['additional_observers_attributes'] = Array(observation['additional_observers_attributes']).map do |ao|
        fix_name(ao)
      end


      %w{melt_pond topography}.each do |attr|
        observation['ice_observations_attributes'].each do |obs_type|
          obs_type["#{attr}_attributes"] = obs_type.delete(attr)
        end
      end

      observation['meteorology_attributes']['clouds_attributes'] = observation['meteorology_attributes'].delete('clouds')

      update_lookup_codes(observation)
      observation
    end

    def update_lookup_codes item
      item.keys.each do |k|
        case
        when k =~ /lookup_code/
          code = item.delete(k)
          key = k.gsub(/biota/,'algae')
          table_name = key.chomp('_code').camelcase
          table = table_name.gsub(/^(Thick|Thin)/,"").constantize
          item[key.gsub(/_code/,"_id")] = table.where(code: code.to_s).first.try(:id)
        when item[k].is_a?(Array)
          item[k].each{|val| update_lookup_codes(val)}
        when item[k].is_a?(Hash)
          update_lookup_codes item[k]
        end
      end
    end

    def fix_name observer
      { name: [observer['firstname'], observer['lastname']].flatten.join(" ") }
    end
  end
end
