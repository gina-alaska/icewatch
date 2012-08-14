class Api::CruisesController < ApiController
  respond_to :json, :geojson#, :csv
 
  def index
    @cruises = Cruise.where(archived: false)
          
    respond_to do |format|
      format.json { render json: @cruises }
      format.geojson { render json: @cruises.collect(&:as_geojson) }
    end
  end
  
  def show
    @cruise = Cruise.where(cruise_id: params[:cruise_id])
    
    respond_to do |format|
      format.json { render json: @cruise }
      format.geojson { render json: @cruise.as_geojson }
    end    
  end
  
  def all
    @cruises = Cruise.all
    
    respond_to do |format|
      format.json { render json: @cruises }
      format.geojson { render json: @cruises.collect(&:as_geojson) }
    end
  end

end