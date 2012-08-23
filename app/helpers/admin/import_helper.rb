module Admin::ImportHelper  
  def options_for_cruise_select obs
    cruise_name = Cruise.where(id: obs.cruise_id).first || Cruise.new(:ship => "UNKNOWN CRUISE")
    imported_as_name = Cruise.where(id: obs.imported_as_cruise_id).first || Cruise.new(:ship => "UNKNOWN CRUISE")
    [
      [cruise_name.ship,obs.cruise_id ], 
      [imported_as_name.ship, obs.imported_as_cruise_id]
    ]
  end
end