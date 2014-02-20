class Sigrid3::ObservationsController < Sigrid3Controller
  respond_to :geojson

  def show
    @observation = observation.where(id: params[:id])
  end

end