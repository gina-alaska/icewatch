class ObservationsController < ApplicationController
  authorize_resource

  before_action :set_observation, only: [:show, :edit, :update, :destroy]

  # GET /observations
  # GET /observations.json
  def index
    @cruise = Cruise.find(params[:cruise_id])
    @observations = @cruise.observations.order(observed_at: :desc).accessible_by(current_ability)
  end

  # GET /observations/1
  # GET /observations/1.json
  def show
  end

  # # GET /observations/new
  # def new
  #   @cruise = Cruise.find(params[:cruise_id])
  #   @observation = @cruise.build_observation
  # end

  # GET /observations/1/edit
  def edit
    @observation.valid?
    @observation.faunas.build
    @observation.photos.build
  end

  # POST /observations
  # POST /observations.json
  def create
    @cruise = Cruise.find(params[:cruise_id])
    @observation = @cruise.build_observation

    respond_to do |format|
      if @observation.save validate: false
        format.html { redirect_to edit_observation_path(@observation), notice: 'Observation was successfully created.' }
        format.json { render :show, status: :created, location: @observation }
      else
        format.html { render :new }
        format.json { render json: @observation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /observations/1
  # PATCH/PUT /observations/1.json
  def update
    @observation.assign_attributes observation_params
    respond_to do |format|
      if @observation.save(validate: false)
        if params[:commit] == 'Save and Exit'
          format.html { redirect_to root_url }
        else
          format.html { redirect_to edit_observation_path(@observation), notice: 'Observation was successfully updated.' }
        end
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /observations/1
  # DELETE /observations/1.json
  def destroy
    @observation.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Observation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    @cruise = Cruise.find params[:cruise_id]

    @csv_observation = CsvObservation.new(import_params)

    respond_to do |format|
      if @csv_observation.errors.any?
        format.json { render json: @csv_observation.errors.full_messages, status: :unprocessable_entity }
      else
        @observation = @csv_observation.build_observation
        @observation.cruise = @cruise
        if @observation.save validate: false
          format.html { redirect_to cruises_url, notice: 'Observations were successfully imported' }
          format.json { head :no_content }
          format.js
          AdminMailer.new_csv_upload(@observation).deliver
        else
          format.html { redirect_to cruises_url, notice: 'There was an error importing the observations' }
          format.json { render json: @observation.errors.full_messages, status: :unprocessable_entity }
        end
      end
    end
  end

  def all
    @cruise = Cruise.find params[:cruise_id]

    @cruise.observations.destroy_all
    respond_to do |format|
      if assist?
        format.html { redirect_to root_url, notice: 'All observations were successfully destoyed.' }
      else
        format.html { redirect_to cruise_url(@cruise), notice: 'All observations were successfully destroyed.' }
      end
    end
  end

  def unapproved
    @cruise = Cruise.find params[:cruise_id]

    @cruise.observations.saved.destroy_all
    respond_to do |format|
      format.html { redirect_to cruise_url(@cruise), notice: 'All unapproved observations were successfully destroyed.' }
    end
  end

  def invalid
    @cruise = Cruise.find params[:cruise_id]
    @observations = @cruise.observations.reject(&:valid?)
    Observation.where(id: @observations).destroy_all

    respond_to do |format|
      format.html { redirect_to cruise_url(@cruise), notice: 'All unapproved observations were successfully destroyed.' }
    end
  end

  def approve
    @observation = Observation.find params[:id]

    if @observation.valid?
      @observation.accept!
    else
      flash[:error] = "Unable to approve an invalid observation"
    end

    redirect_to cruise_path(@observation.cruise)
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_observation
    @observation = Observation.where(id: params[:id]).includes(:ice_observations).first
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def observation_params
    params.require(:observation).permit(
      :cruise_id, :observed_at, :latitude, :longitude, :uuid,
      :lat_minutes, :lat_seconds, :lon_minutes, :lon_seconds,
      :primary_observer_id_or_name, additional_observers_id_or_name: [],
                                    ship_attributes: [:id, :heading, :power, :speed, :ship_activity_lookup_id],
                                    notes_attributes: [:id, :text],
                                    ice_attributes: [:id, :total_concentration, :open_water_lookup_id,
                                                     :thick_ice_lookup_id, :thin_ice_lookup_id],
                                    ice_observations_attributes: [:id, :partial_concentration, :ice_lookup_id,
                                                                  :thickness, :floe_size_lookup_id, :snow_lookup_id, :snow_thickness,
                                                                  :algae_lookup_id, :algae_density_lookup_id, :algae_location_lookup_id,
                                                                  :sediment_lookup_id, :obs_type,
                                                                  topography_attributes: [:id, :concentration, :ridge_height, :consolidated,
                                                                                          :snow_covered, :old, :topography_lookup_id
                                                                                         ],
                                                                  melt_pond_attributes: [:id, :surface_coverage, :pattern_lookup_id,
                                                                                         :surface_lookup_id, :freeboard, :max_depth_lookup_id, :bottom_type_lookup_id,
                                                                                         :dried_ice, :rotten_ice
                                                                                        ]
                                                                 ],
                                    meteorology_attributes: [:id, :visibility_lookup_id, :weather_lookup_id,
                                                             :total_cloud_cover, :wind_speed, :wind_direction, :water_temperature,
                                                             :air_pressure, :air_temperature, :relative_humidity,
                                                             clouds_attributes: [:id, :cloud_lookup_id, :cover, :height, :cloud_type]
                                                            ],
                                    faunas_attributes: [:id, :name, :count, :_destroy],
                                    photos_attributes: [:id, :file, :on_boat_location_lookup_id, :_destroy]
    )
  end

  def import_params
    params.require(:observation).permit!
  end
end
