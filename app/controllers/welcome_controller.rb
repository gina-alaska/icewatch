class WelcomeController < ApplicationController
  respond_to :html, :json

  def index
    @cruises = Cruise.where(:id => params[:cruise][:_id]) if params[:id]
    @cruises ||= Cruise.asc(:start_date).includes(:observations)
    #@observations = Observation.where(:obs_datetime.lt => Date.parse("2010-1-1")).asc(:obs_datetime)
    
  end
  
end