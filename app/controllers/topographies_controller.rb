class TopographiesController < ApplicationController
  before_action :set_topography, only: [:show, :edit, :update, :destroy]

  # GET /topographies
  # GET /topographies.json
  def index
    @topographies = Topography.all
  end

  # GET /topographies/1
  # GET /topographies/1.json
  def show
  end

  # GET /topographies/new
  def new
    @topography = Topography.new
  end

  # GET /topographies/1/edit
  def edit
  end

  # POST /topographies
  # POST /topographies.json
  def create
    @topography = Topography.new(topography_params)

    respond_to do |format|
      if @topography.save
        format.html { redirect_to @topography, notice: 'Topography was successfully created.' }
        format.json { render :show, status: :created, location: @topography }
      else
        format.html { render :new }
        format.json { render json: @topography.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topographies/1
  # PATCH/PUT /topographies/1.json
  def update
    respond_to do |format|
      if @topography.update(topography_params)
        format.html { redirect_to @topography, notice: 'Topography was successfully updated.' }
        format.json { render :show, status: :ok, location: @topography }
      else
        format.html { render :edit }
        format.json { render json: @topography.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topographies/1
  # DELETE /topographies/1.json
  def destroy
    @topography.destroy
    respond_to do |format|
      format.html { redirect_to topographies_url, notice: 'Topography was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_topography
    @topography = Topography.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def topography_params
    params.require(:topography).permit(:ice_observation_id, :old, :snow_covered, :concentration, :ridge_height, :topography_lookup_id)
  end
end
