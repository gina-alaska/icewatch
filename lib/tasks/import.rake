namespace :import do
  namespace :legacy do
    desc 'Import users from the live site'
    task users: :environment do
      require 'httparty'
      response = HTTParty.get('http://icewatch.gina.alaska.edu/api/users.json')
      users = JSON.parse(response.body)

      users.each do |user|
        u = User.where(email: user['email']).first_or_initialize
        puts "#{u.new_record? ? 'Creating' : 'Updating'} #{user['email']}"
        u.name = user['name']
        u.role = 'member' if user['approved']
        u.role = 'admin' if user['admin']
        user['cruises'].each do |cruise|
          puts "Looking for #{cruise['ship']}: #{cruise['start_date']} - #{cruise['end_date']}"
          crs = Cruise.where(ship: cruise['ship'], starts_at: cruise['start_date'], ends_at: cruise['end_date'])

          # Some users created multiple copies of their cruise.
          # Preserve that and let the admins clean it up
          crs.each do |c|
            if u.cruises.include?(c)
              puts "Skipping #{c.ship}"
            else
              puts "Adding #{c.ship}"
              u.cruises << c
            end
          end
        end

        u.save
      end
    end

    desc 'Import cruises from the live site'
    task cruises: :environment do
      require 'httparty'
      require 'csv'

      response = HTTParty.get('http://icewatch.gina.alaska.edu/api/cruises/all.json')
      cruises = JSON.parse(response.body)

      puts "Fetched #{cruises.count} cruises"
      cruises.each do |cruise|
        puts "Fetching #{cruise['ship']} - #{cruise['start_date']} - #{cruise['_id']}"

        observations = cruise.delete('observations')
        original_id = cruise.delete('_id')

        import_cruise = Cruise.where(cruise_params(cruise)).first_or_initialize

        import_cruise.save(validate: false) if import_cruise.new_record?

        csv_observations = fetch_observations_for_cruise(original_id)

        puts " -- Fetched #{csv_observations.split("\n").count} observations"
        CSV.parse(csv_observations, headers: true).each do |row|
          begin
            csv_observation = CsvObservation.new(row.to_hash)
          rescue Exception
            puts "Failed to create: "
            puts row
            puts row.inspect
            puts row.to_hash
            raise
          end
          observation = csv_observation.build_observation
          observation.cruise = import_cruise
          observation.save!(validate: false)
        end
      end
    end

    def fetch_observations_for_cruise(original_id)
      url = "http://icewatch.gina.alaska.edu/api/cruises/#{original_id}/observations/all.csv"
      HTTParty.get(url).body
    end

    def cruise_params(cruise)
      valid_keys = %w(
        approved captain
        chief_scientist name end_date
        start_date objective primary_observer
        ship
      )
      cruise.keep_if { |k, _v| valid_keys.include?(k.to_s) }
      cruise['starts_at'] = cruise.delete('start_date')
      cruise['ends_at'] = cruise.delete('end_date')
      cruise
    end

    def observation_attributes(observation)
      observation['observed_at'] = observation.delete('obs_datetime')
      %w(ship ice meteorology notes ice_observations primary_observer additional_observers).each do |attr|
        observation["#{attr}_attributes"] = observation.delete(attr) if observation.key? attr
      end

      observation['primary_observer_attributes'] = fix_name(observation['primary_observer_attributes'])

      observation['additional_observers_attributes'] = Array(observation['additional_observers_attributes']).map do |ao|
        fix_name(ao)
      end

      %w(melt_pond topography).each do |attr|
        observation['ice_observations_attributes'].each do |obs_type|
          obs_type["#{attr}_attributes"] = obs_type.delete(attr)
        end
      end

      observation['meteorology_attributes']['clouds_attributes'] = observation['meteorology_attributes'].delete('clouds')

      update_lookup_codes(observation)
      observation
    end

    def update_lookup_codes(item)
      item.keys.each do |k|
        case
        when k =~ /lookup_code/
          code = item.delete(k)
          key = k.gsub(/biota/, 'algae')
          table_name = key.chomp('_code').camelcase
          table = table_name.gsub(/^(Thick|Thin)/, '').constantize
          item[key.gsub(/_code/, '_id')] = table.where(code: code.to_s).first.try(:id)
        when item[k].is_a?(Array)
          item[k].each { |val| update_lookup_codes(val) }
        when item[k].is_a?(Hash)
          update_lookup_codes item[k]
        end
      end
    end

    def fix_name(observer)
      { name: [observer['firstname'], observer['lastname']].flatten.join(' ') }
    end
  end
end
