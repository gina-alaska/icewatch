class Admin::ObservationsController < AdminController
  respond_to :html
  def index
    @observations = Observation.where(accepted: false).all
    
    respond_to do |format|
      format.html { render :index }
    end
  end
  
  def approve
    @observation = Observation.where(accepted: false, id: params[:id]).first
        
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
  
  def approve_all
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