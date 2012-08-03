class Admin::CruisesController < AdminController
  respond_to :html
  
  def index
    
  end
  
  def new
    @cruise = Cruise.new
  end
  
  def create 
    @cruise = Cruise.new cruise_params
    
    if @cruise.save
      redirect_to admin_cruise_url @cruise
    else
      render action: :new
    end
  end
  
  def approve
    @cruise = Cruise.find(params[:id])
    
    if @cruise
      @cruise.approved = approve_params
      if @cruise.save
        respond_to do |format|
          format.html { redirect_to admin_cruises_url }
        end
      end
    end
  end


protected
  def cruise_params
    params.slice(:cruise)
  end
  
  def approve_params
    params[:value] == "yes" ? true : false
  end

end