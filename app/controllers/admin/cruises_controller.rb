class Admin::CruisesController < AdminController
  before_action :set_cruise, only: [:show, :edit, :update, :destroy]
  def index
    @cruises = Cruise.all
  end

  def show

  end

  private
  def set_cruise
    # @cruise = Cruise.friendly.find(params[:id])
    @cruise = Cruise.find(params[:id])
  end
end
