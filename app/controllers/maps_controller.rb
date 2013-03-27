class MapsController < ApplicationController
  layout "simple"
  
  def show
    @cruises = Cruise.year(@year)
  end  
end