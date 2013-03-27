class CruisesController < ApplicationController
  before_filter :logged_in?, except: [:index,:show]
  
  def create
    @cruise = Cruise.new cruiseParams
    #Load the observations from 
    @cruise.user_id = current_user.id
    if @cruise.save
      if request.xhr?
        render @cruise, layout: false
      else
        redirect_to user_url(current_user.id)
      end
    else
      render action: :new
    end
  end
  
  def update
    @cruise = Cruise.where(id:params[:id]).first
    unless current_user.admin? or @cruise.user_id == current_user.id 
      redirect_to root_url 
    end
    
    if @cruise.update_attributes cruiseParams
      redirect_to cruise_path(@cruise)
    else
      render action: :edit
    end
  end
  
  def edit
    @cruise = Cruise.where(id: params[:id]).first
  end
  
  def index
    @cruises = Cruise.year(@year)
    
    respond_to do |format|
      format.html
    end 
  end
  
  def show
    @cruise = Cruise.where(id: params[:id]).includes(:observations).first
    @observations = @cruise.observations.asc(:obs_datetime)
    @year = @cruise.start_date.beginning_of_year
    
    render layout: !request.xhr?
  end
  
  def graph
    @cruise = Cruise.where(id: params[:id]).includes(:observations).first
    @observations = @cruise.observations.asc(:obs_datetime)
  end
  def photo
    @cruise = Cruise.where(id: params[:id]).includes(:photos).first
  end

  def new
    @cruise = Cruise.new
  end

  private
  def cruiseParams
    params[:cruise].slice(:ship, :start_date, :end_date, :captain, :objective, :chief_scientist, :primary_observer)
  end
  
end
