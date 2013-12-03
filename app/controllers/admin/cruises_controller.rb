class Admin::CruisesController < AdminController
  respond_to :html
  def index
    @all_cruises = Cruise.only(:start_date)
    @cruises = Cruise.desc(:approved).desc(:start_date,:end_date)
    if params[:year]
      year = Time.utc(params[:year])
      @cruises = @cruises.between(start_date: [year, year.end_of_year])
    end
  end
  
  def new
    @cruise = Cruise.new
  end
  
  def show
    @cruise = Cruise.where(id: params[:id]).first
    @pending = @cruise.observations.where(accepted: false)
    @observations = @cruise.observations
    @uploaded_observation = UploadedObservation.new
    
    respond_to do |format|
      format.html { render layout: false if request.xhr?}
    end
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
  
  def accept_observations
    @cruise = cruise.where(id: params[:id]).first
    @observations = observation.where(cruise_id: @cruise.id).in(id: params[:observation_ids])
    
    @observations.update_all(accepted: true)
  end
  def reject_observations
    @cruise = cruise.where(id: params[:id]).first
    @observations = observation.where(cruise_id: @cruise.id).in(id: params[:observation_ids])
    @ids = @observations.collect(&:id)
    @observations.destroy_all
  end


protected
  def cruise_params
    params.slice(:cruise)
  end
  
  def approved?
    params[:value] == "yes" ? true : false
  end

end