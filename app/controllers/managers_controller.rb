class ManagersController < ApplicationController
  respond_to :html
  def show
    @cruises = Cruise.all
    
    respond_with @cruises
  end
  
  def index
    
  end
end
