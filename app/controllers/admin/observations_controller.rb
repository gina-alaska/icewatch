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

  def accept
    @observation = observation.where(accepted: false, id: params[:id]).first

    if @observation and @observation.update_attribute(:accepted, true)
      flash[:notice] = "Accepted observation"
      redirect_to admin_cruise_path(@observation.cruise)
    else
      if @observation.nil?
        flash[:error] = "Unable to find observation or observation has already been approved"
        redirect_to admin_cruises_path
      else
        flash[:error] = "Unable to update observation"
        redirect_to admin_cruise_path(@observation.cruise)
      end
    end
  end
  
  def reject
    @observation = observation.where(accepted: false, id: params[:id]).first
    
    if @observation and @observation.delete
      flash[:notice] = "Rejected observation"
      redirect_to admin_cruise_path(@observation.cruise)
    else
      if @observation.nil?
        flash[:error] = "Unable to find observation or observation has already been approved"
        redirect_to admin_cruises_path
      else
        flash[:error] = "Something went wrong"
        redirect_to admin_cruise_path(@observation.cruise)  
      end
    end
  end
  
  private
  def accepted?
    params[:value] == "yes" ? true : false
  end
end