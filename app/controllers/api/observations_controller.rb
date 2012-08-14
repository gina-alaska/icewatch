class Api::ObservationsController < ApiController
  respond_to :json, :geojson#, :csv

  def index
    @observations = Observation.where(cruise_id: params[:cruise_id])

    respond_to do |format|
      format.json { render json: @observations }
      format.geojson { render json: @observations.collect(&:as_geojson) }
      format.csv {render text: @observations.collect(&:as_csv)}
    end
  end

  def show
    @observation = Observation.where(id: params[:id])
    
    respond_to do |format|
      format.json { render json: @observation }
      format.geojson { render json: @observation.as_geojson }
      format.csv { render text: @observation.inspect }
    end
  end

end