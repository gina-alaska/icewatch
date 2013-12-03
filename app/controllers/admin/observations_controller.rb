class Admin::ObservationsController < AdminController
  respond_to :html
  def index
    @observations = observation.where(accepted: false).all
    
    respond_to do |format|
      format.html { render :index }
    end
  end
  
  def show
    @observation = observation.where(accepted: false,id: params[:id]).first
    
    respond_to do |format|
      format.html
    end
  end
  
  def approve
    @observation = observation.where(accepted: false, id: params[:id]).first
        
    if(@observation)
      if accepted?
        @observation.accepted = true
        @observation.save
      else
        @observation.delete
      end
    end
    redirect_to admin_observations_url 
  end
  
  def accept
    @observation = observation.where(accepted: false, id: params[:id]).first
    
    if @observation.update_attribute(accepted: true)
      redirect_to admin_observations_url
    else
      
    end
  end
  
  def reject
    @observation = observation.where(accepted: false, id: params[:id]).first
    
    if @observation.delete
      redirect_to 
    else
      
    end
  end
  
  def approve_selected
    @observations = Observation.where(accepted: false)
  
    if params[:cruise_id]
      @observations = @observations.where(cruise_id: params[:cruise_id])
    end
    #Todo: Figure out why update_all isnt' working
    #@observations.update_all(accepted: true)
    
    @observations.each{|obs| obs.update_attributes(accepted: true)}
    
    if params[:cruise_id]
      redirect_to admin_cruise_url(params[:cruise_id])
    else
      redirect_to admin_observations_url
    end
  end
  
  private
  def accepted?
    params[:value] == "yes" ? true : false
  end
end