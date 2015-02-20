json.extract! ice_observation, :obs_type, :partial_concentration, :algae_density_lookup_code,
              :algae_location_lookup_code, :algae_lookup_code, :floe_size_lookup_code,
              :ice_lookup_code, :sediment_lookup_code, :snow_lookup_code, :snow_thickness,
              :thickness
json.topography ice_observation.topography, :concentration, :ridge_height,
                :consolidated, :old, :snow_covered, :topography_lookup_code
json.melt_pond ice_observation.melt_pond, :bottom_type_lookup_code, :dried_ice,
               :freeboard, :max_depth_lookup_code, :pattern_lookup_code, :rotten_ice,
               :surface_coverage, :surface_lookup_code
