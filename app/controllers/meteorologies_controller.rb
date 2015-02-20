class MeteorologiesController < ApplicationController
  before_action :set_meteorology, only: [:show, :edit, :update, :destroy]

  # GET /meteorologies
  # GET /meteorologies.json
  def index
    @meteorologies = Meteorology.all
  end

  # GET /meteorologies/1
  # GET /meteorologies/1.json
  def show
  end

  # GET /meteorologies/new
  def new
    @meteorology = Meteorology.new
  end

  # GET /meteorologies/1/edit
  def edit
  end

  # POST /meteorologies
  # POST /meteorologies.json
  def create
    @meteorology = Meteorology.new(meteorology_params)

    respond_to do |format|
      if @meteorology.save
        format.html { redirect_to @meteorology, notice: 'Meteorology was successfully created.' }
        format.json { render :show, status: :created, location: @meteorology }
      else
        format.html { render :new }
        format.json { render json: @meteorology.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meteorologies/1
  # PATCH/PUT /meteorologies/1.json
  def update
    respond_to do |format|
      if @meteorology.update(meteorology_params)
        format.html { redirect_to @meteorology, notice: 'Meteorology was successfully updated.' }
        format.json { render :show, status: :ok, location: @meteorology }
      else
        format.html { render :edit }
        format.json { render json: @meteorology.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meteorologies/1
  # DELETE /meteorologies/1.json
  def destroy
    @meteorology.destroy
    respond_to do |format|
      format.html { redirect_to meteorologies_url, notice: 'Meteorology was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_meteorology
    @meteorology = Meteorology.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def meteorology_params
    params.require(:meteorology).permit(:observation_id, :weather_lookup_id, :visibility_lookup_id, :total_cloud_cover, :wind_speed, :wind_direction, :air_temperature, :water_temperature, :realtive_humidity, :air_pressure)
  end
end
