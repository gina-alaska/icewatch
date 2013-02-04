module CruisesHelper
  def observations_grouped_by_ice_type observations
    
    ice_obs = observations.collect(&:ice_observations).flatten
    
    ice_obs.collect!{|i| [i.ice_lookup.try(:name).try(:html_safe), i.partial_concentration.to_i] }        
        
    result = ice_obs.inject(Hash.new(0)) do |h,i|
      # i = [ ice_lookup, partial_concentration ]
      # Only add values if there was an observation made
      unless i.first.nil?
        h[i.first] += i.last.to_i
      end
      h
    end

    concentration = observations.count * 10;
    result["Water"] = concentration - result.values.inject(&:+).to_i 
    #Scale the values to be between 0 and 1
    result.each{|k,v| result[k] = v.to_f / concentration.to_f}    
    
    result 
  end
  
  def concentration_grouped_by_ice_age observations     
    groups = Hash.new    
    observations.each do |obs|
      %w{new first_year old}.each do |type|
        groups[type] ||= []
        groups[type] << [obs.obs_datetime.to_i * 1000, obs.ice_observations.send("#{type}_ice_concentration") ]
      end
    end
    
    groups.inject([]) do |arr, (k,v)|
      arr << {key: "#{k.humanize} Ice", values: v}
    end
  end
  
  def total_concentration_grouped_by_time observations
    observations.collect{|o| [o.obs_datetime.to_i * 1000, o.ice.total_concentration.to_i]} 
  end
  
  
  def concentration_grouped_by_type observations
    groups = Hash.new()
    observations.each do |obs|
      obs.ice_observations.each do |i|
        next if i.obs_type.nil?
        groups[i.obs_type.to_sym] ||= []
        groups[i.obs_type.to_sym].push([obs.obs_datetime.to_i * 1000, i.partial_concentration.to_i])
      end
    end

    
    result = groups.inject([]) do |arr,(k,v)|
      arr << {key: "#{k.capitalize} Concentration", values: v}
      arr
    end
    result
  end
end
