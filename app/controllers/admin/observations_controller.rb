class Admin::ObservationsController < AdminController
  respond_to :html
  def index
    @observations = Observation.where(accepted: false)
    
    respond_to do |format|
      if request.xhr?
        format.html { render partial: 'admin/observations/pending', layout: false }
      else
        format.html { render :index }
      end
    end
  end
  
  def approve
    @observation = Observation.where(accepted: false, id: params[:id]).first
        
    if(@observation)
      @observation.accepted = accepted_params
      
      if @observation.save 
        respond_to do |format|
          format.html { redirect_to admin_observations_url }
        end
      end
    end
  end
  
  private
  def accepted_params
    params[:value] == "yes" ? true : false
  end
end