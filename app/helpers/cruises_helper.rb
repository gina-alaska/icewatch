module CruisesHelper
  def observations_grouped_by_ice_type observations
  
    ice_obs = observations.collect(&:ice_observations).flatten
    
    ice_obs.collect!{|i| [i.ice_lookup.try(:name).try(:html_safe), i.partial_concentration] }        
      
    result = ice_obs.inject(Hash.new(0)) do |h,i|
      # i = [ ice_lookup, partial_concentration ]
      if i.last == 0 || i.last.nil?
        h[i.first] += 0
      else
        h[i.first] += 1.0 / i.last
      end
      h
    end
    
    result 
  end
  
  def total_concentration_grouped_by_time observations
    observations.collect{|o| [o.obs_datetime.to_i * 1000, o.ice.total_concentration]} 
  end
  
  
  def concentration_grouped_by_type observations
    groups = Hash.new()
    observations.each do |obs|
      obs.ice_observations.each do |i|
        next if i.obs_type.nil?
        groups[i.obs_type.to_sym] ||= []
        groups[i.obs_type.to_sym].push([obs.obs_datetime.to_i * 1000, i.partial_concentration])
      end
    end

    
    result = groups.inject([]) do |arr,(k,v)|
      arr << {key: "#{k.capitalize} Concentration", values: v}
      arr
    end
    result
  end
end
