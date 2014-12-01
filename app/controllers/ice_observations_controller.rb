class IceObservationsController < ApplicationController
  before_action :set_ice_observation, only: [:show, :edit, :update, :destroy]

  # GET /ice_observations
  # GET /ice_observations.json
  def index
    @ice_observations = IceObservation.all
  end

  # GET /ice_observations/1
  # GET /ice_observations/1.json
  def show
  end

  # GET /ice_observations/new
  def new
    @ice_observation = IceObservation.new
  end

  # GET /ice_observations/1/edit
  def edit
  end

  # POST /ice_observations
  # POST /ice_observations.json
  def create
    @ice_observation = IceObservation.new(ice_observation_params)

    respond_to do |format|
      if @ice_observation.save
        format.html { redirect_to @ice_observation, notice: 'Ice observation was successfully created.' }
        format.json { render :show, status: :created, location: @ice_observation }
      else
        format.html { render :new }
        format.json { render json: @ice_observation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ice_observations/1
  # PATCH/PUT /ice_observations/1.json
  def update
    respond_to do |format|
      if @ice_observation.update(ice_observation_params)
        format.html { redirect_to @ice_observation, notice: 'Ice observation was successfully updated.' }
        format.json { render :show, status: :ok, location: @ice_observation }
      else
        format.html { render :edit }
        format.json { render json: @ice_observation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ice_observations/1
  # DELETE /ice_observations/1.json
  def destroy
    @ice_observation.destroy
    respond_to do |format|
      format.html { redirect_to ice_observations_url, notice: 'Ice observation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ice_observation
      @ice_observation = IceObservation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ice_observation_params
      params.require(:ice_observation).permit(:observation_id, :floe_size_lookup_id, :snow_lookup_id, :ice_lookup_id, :algae_lookup_id, :algae_density_lookup_id, :algae_density_lookup_id, :sediment_lookup_id, :partial_concentration, :thickness, :snow_thickness, :obs_type)
    end
end
