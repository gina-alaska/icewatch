class Admin::CruisesController < AdminController
  respond_to :html
  
  def index
    
  end
  
  def new
    @cruise = Cruise.new
  end
  
  def show
    @cruise = Cruise.where(id: params[:id]).first
    @pending = @cruise.observations.where(accepted: false)
    @observations = @cruise.observations
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
      if approved?
        @cruise.approved = true
        if @cruise.save
          respond_to do |format|
            format.html { redirect_to admin_cruises_url }
          end
        end
      else
        @cruise.delete
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
  
  def approved?
    params[:value] == "yes" ? true : false
  end

end