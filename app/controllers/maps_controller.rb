class MapsController < ApplicationController
  layout "simple"
  
  def show
    @year = Date.today.beginning_of_year
    @cruises = Cruise.year(@year)
    
  end
  
end