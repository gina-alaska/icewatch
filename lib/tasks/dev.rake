namespace :dev do
  desc 'Populate the database with sample data'
  task prime: :environment do
    100.times { Person.create(name: Forgery('name').full_name) }
    15.times do
      cruise = generate_cruise
      rand(2..200).times do
        generate_observation_for(cruise)
      end
    end
  end

  def generate_cruise
    Cruise.create(
      captain: Forgery('name').full_name,
      primary_observer: sample(Person).first,
      chief_scientist: Forgery('name').full_name,
      objective: Forgery('lorem_ipsum').sentence,
      starts_at: Forgery('date').date(max_delta: (365 * 5)),
      ends_at: Forgery('date').date(max_delta: (365 * 5)),
      ship: Forgery('name').company_name,
      approved: [true, true, true, false].sample
    )
  end

  def generate_observation_for(cruise)
    o = cruise.build_observation

    o.observed_at = cruise.starts_at + (rand(0..(20 * 24 * 60))).minutes
    o.primary_observer = sample(Person).first
    # o.additional_observers = sample(Person, rand(0..5))
    o.latitude = Forgery('geo').latitude
    o.longitude = Forgery('geo').longitude
    generate_ice(o.ice)
    generate_meteorology(o.meteorology)
    o.photos = rand(0..10).times.map{generate_photo}
    o.save(validate: false)
  end

  def generate_ice ice
    ice.total_concentration = rand(0..10)
    ice.open_water_lookup = sample(OpenWaterLookup).first
    ice.thick_ice_lookup = sample(IceLookup).first
    ice.thin_ice_lookup = sample(IceLookup).first
  end

  def generate_meteorology met
    met.weather_lookup = sample(WeatherLookup).first
    met.visibility_lookup = sample(VisibilityLookup).first
  end

  def generate_photo
    Photo.new(name: Forgery('name').company_name,
              on_boat_location_lookup_id: sample(OnBoatLocationLookup).first,
              note: Forgery('lorem_ipsum').sentence,
              file: File.open('test/fixtures/images/vegas.jpg'))
  end

  def sample( model, count = 1 )
    result = model.limit(count).order("RANDOM()")
  end
end