module Importable::Ice
  extend ActiveSupport::Concern

  ASSIGNABLE_ATTRIBUTES = %w( open_water_lookup thick_ice_lookup
                              thin_ice_lookup total_concentration )


  def from_json(json)
    obs_data = json.dup

    
    assign_attributes(json.values_at(ASSIGNABLE_ATTRIBUTES)
  end
