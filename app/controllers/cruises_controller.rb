class CruisesController < ApplicationController
  before_filter :logged_in?, except: [:show]
  
  
  def create
    @cruise = Cruise.new cruiseParams
    #Load the observations from 
    @cruise.user_id = current_user.id
    if @cruise.save
      if request.xhr?
        render @cruise, layout: false
      else
        redirect_to cruises_url
      end
    else
      render action: :new
    end
  end
  
  def index
    @cruises = current_user.admin? ? Cruise.all : Cruise.where(:created_by => current_user.id)
    
    respond_to do |format|
      format.html
    end 
  end
  
  def show
    @cruise = Cruise.where(id: params[:id]).includes(:observations).first#.where('observations.accepted' => true)
    
    respond_to do |format|
      format.html
    end
  end

protected
  def cruiseParams
    params[:cruise].slice(:ship, :start_date, :end_date, :captain)
  end
end
