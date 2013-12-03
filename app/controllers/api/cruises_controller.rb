class Api::CruisesController < ApiController
  respond_to :json, :geojson#, :csv
  
 
  def index
    @cruises = cruise.where(archived: false)
    @cruises = @cruises.between(start_date: [@year,@year+1.year]).or.between(end_date: [@year,@year+1.year])
    
    respond_to do |format|
      format.json { render json: @cruises }
      format.geojson { render json: {
        type: 'FeatureCollection',
        features: @cruises.collect(&:as_geojson).compact.flatten
      }}
    end
  end
  
  def show    
    @cruise = cruise.where(id: params[:id])
    Rails.logger.info(@cruise.count)
    @cruise = filter_cruises(@cruise)
    
    respond_to do |format|
      format.json { render json: @cruise }
      format.geojson { render json: {
        type: 'FeatureCollection',
        features: @cruise.as_geojson 
      }}
    end    
  end
  
  def all
    @cruises = cruise.all
    
    respond_to do |format|
      format.json { render json: @cruises }
      format.geojson { render json: @cruises.collect(&:as_geojson) }
    end
  end

end