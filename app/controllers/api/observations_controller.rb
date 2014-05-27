class Api::ObservationsController < ApiController
  respond_to :json, :geojson, :csv

  def index
    @observations = observation.where(cruise_id: params[:cruise_id])

    respond_to do |format|
      format.json { render json: @observations }
      format.geojson { render json: {
        type: 'FeatureCollection',
        features: @observations.collect(&:as_geojson).compact
      }}
      format.csv { render text: generate_csv }
    end
  end

  def show
    @observation = observation.where(id: params[:id])
    
    respond_to do |format|
      format.json { render json: @observation }
      format.geojson { render json: @observation.as_geojson }
      format.csv { render text: @observation.inspect }
    end
  end

private
  def generate_csv
    ::CSV.generate({:headers => true}) do |csv|
      csv << Observation.headers
      Array(@observations).each do |o|
        csv << o.as_csv
      end
    end
  end
  
end
