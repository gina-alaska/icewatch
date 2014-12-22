module Converters
  module JSON
    def build_observation
      params = transform_lookups(self.to_observation_json)
      o = Observation.new observation_attributes(params)
      o.primary_observer = person(params[:primary_observer])
      o.additional_observers = Array(params[:additional_observers]).map{|p| person(p)}
      o.ice = Ice.new(params[:ice])

      %w{primary secondary tertiary}.each do |obs_type|
        #o.primary_ice_observation = ice_observation(ice_observation_attributes(params, 'primary'))
        o.send("#{obs_type}_ice_observation=", ice_observation(ice_observation_attributes(params, obs_type)))
      end
      o.meteorology = meteorology(meteorology_attributes(params))

      o.faunas = Array(params[:faunas]).map{|f| Fauna.new(f)}
      # o.notes = Array(params[:notes]).map{|n| Note.new(n)}
      o.ship = params[:ship]

      o
    end


    private
    def person params
      Person.where(params).first_or_initialize
    end

    def observation_attributes params
      params.extract! :latitude, :longitude, :observed_at
    end

    def ice_observation_attributes params, obs_type
      params.extract! "#{obs_type}_ice_observation".to_sym  # params.extract "primary_ice_observation".to_sym
    end

    def topography_attributes params
      params.extract! :topography
    end

    def melt_pond_attributes params
      params.extract! :melt_pond
    end

    def cloud_attributes params, cloud_type
      params.extract! "#{cloud_type}_cloud".to_sym  # params.extract "high_cloud".to_sym
    end

    def transform_lookups params
      params.transform_keys!{|k| k.to_s.gsub(/_code/, '_id')}

      params.each do |key, value|
        if value.is_a? Hash
          transform_lookups(value)
        elsif key =~ /_lookup_id/
          table = key.chomp("_id").gsub(/(thin|thick)/,'').camelize.constantize
          params[key] = table.where(code: value).first
        end
      end

    end

    def ice_observation attributes
      ta = topography_attributes(attributes)
      mpa = melt_pond_attributes(attributes)
      io = IceObservation.new attributes
      io.topography = Topography.new ta
      io.melt_pond = MeltPond.new mpa

      io
    end

    def meteorology_attributes(attributes)
      attributes.extract! :metorology
    end

    def meteorology attributes
      hc = cloud_attributes(attributes, 'high')
      mc = cloud_attributes(attributes, 'medium')
      lc = cloud_attributes(attributes, 'low')

      m = Meteorology.new attributes
      m.high_cloud = Cloud.new hc
      m.medium_cloud = Cloud.new mc
      m.low_cloud = Cloud.new lc

      m
    end

  end
end
