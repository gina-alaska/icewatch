module Converters
  module JSON
    def build_observation
      params = transform_lookups(self.to_observation_json)
      o = Observation.new observation_attributes(params)
      o.primary_observer = person(params[:primary_observer])
      o.additional_observers = Array(params[:additional_observers]).map{|p| person(p)}
      o.ice = Ice.new(params[:ice])

      %w{primary secondary tertiary}.each do |obs_type|
        o.ice_observations << ice_observation(obs_type, ice_observation_attributes(params, obs_type))
      end
      o.meteorology = meteorology(meteorology_attributes(params))

      o.faunas = Array(params[:faunas]).map{|f| Fauna.new(f)}
      o.notes = Array(params[:notes]).map{|n| Note.new(n)}
      o.ship = Ship.new(params[:ship])
      o.comments = build_comments(params[:comments])
      o
    end


    private
    def person params
      Person.where(params).first_or_create
    end

    def observation_attributes params
      params.extract! :latitude, :longitude, :observed_at
    end

    def ice_observation_attributes params, obs_type
      params.with_indifferent_access["#{obs_type}_ice_observation"]
    end

    def topography_attributes params
      params.delete(:topography)
    end

    def melt_pond_attributes params
      params.delete(:melt_pond)
    end

    def cloud_attributes params, cloud_type
      params.delete "#{cloud_type}_cloud".to_sym
    end

    def transform_lookups params
      params.transform_keys!{|k| k.to_s.gsub(/_code/, '_id').to_sym}

      params.each do |key, value|
        if value.is_a? Hash
          transform_lookups(value)
        elsif key =~ /_lookup_id/
          table_name = key.to_s.chomp("_id")
          table_name.gsub!(/(thin|thick)/,'')
          table_name.gsub!(/biota/,'algae')
          table = table_name.camelize.constantize
          params[key] = table.where(code: value).first.try(:id)
        end
      end

    end

    def ice_observation obs_type, attributes
      ta = topography_attributes(attributes)
      mpa = melt_pond_attributes(attributes)
      io = IceObservation.send(obs_type.to_sym).new attributes
      io.topography = Topography.new ta
      io.melt_pond = MeltPond.new mpa

      io
    end

    def meteorology_attributes(attributes)
      attributes.delete :meteorology
    end

    def meteorology attributes
      hc = cloud_attributes(attributes, 'high')
      mc = cloud_attributes(attributes, 'medium')
      lc = cloud_attributes(attributes, 'low')

      m = Meteorology.new attributes
      m.high_cloud = Cloud.high.new hc
      m.medium_cloud = Cloud.medium.new mc
      m.low_cloud = Cloud.low.new lc

      m
    end

    def build_comments params
      comments = params.map do |comment|
        Comment.new(text: comment[:text], person_id: person(comment[:person]).id)
      end
      comments
    end

  end
end
