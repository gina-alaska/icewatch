class Sigrid3::CruisesController < Sigrid3Controller
  respond_to :geojson, :zip

  def show
    @cruise = cruise.where(id: params[:id]).first
  end

end
