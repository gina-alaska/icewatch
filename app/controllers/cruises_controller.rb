class CruisesController < ApplicationController
  authorize_resource

  before_action :set_cruise, only: [:show, :edit, :update, :destroy, :approve, :reject]
  before_action :set_active_cruise, only: [:index, :show]
  before_action :set_observations, only: [:show]
  before_action :set_current_year, only: [:index]
  # respond_to :geojson, :json, :csv, :zip
  # GET /cruises
  # GET /cruises.json
  def index
    @cruises = Cruise.accessible_by(current_ability).for_year(@current_year).order(starts_at: :desc)
    @available_years = Cruise.accessible_by(current_ability).start_dates.group_by(&:year)
    if Rails.application.secrets.icewatch_assist && @cruises.empty?
      redirect_to new_cruise_path
    end
  end

  # GET /cruises/1
  # GET /cruises/1.json
  def show
    if @cruise.approved? or can?(:read, @cruise)
      respond_to do |format|
        format.html
        format.geojson
        format.json
        format.csv
        format.zip do
          send_data File.read(@cruise.zip!(@observations, !!params[:photos]))
        end
      end
    else
      redirect_to root_url, alert: "You don't have access to that cruise"
    end
  end

  # GET /cruises/new
  def new
    @cruise = Cruise.new
  end

  # GET /cruises/1/edit
  def edit
  end

  # POST /cruises
  # POST /cruises.json
  def create
    @cruise = Cruise.new(cruise_params)
    unless current_user.new_record?
      @cruise.users = [current_user]
    end

    respond_to do |format|
      if @cruise.save
        format.html { redirect_to after_modify_path, notice: 'Cruise was successfully created.' }
        format.json { render :show, status: :created, location: @cruise }
        AdminMailer.new_cruise(@cruise, current_user).deliver
      else
        format.html { render :new }
        format.json { render json: @cruise.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cruises/1
  # PATCH/PUT /cruises/1.json
  def update
    respond_to do |format|
      if @cruise.update_attributes(cruise_params)
        format.html { redirect_to after_modify_path, notice: 'Cruise was successfully updated.' }
        format.json { render :show, status: :ok, location: @cruise }
      else
        format.html { render :edit }
        format.json { render json: @cruise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cruises/1
  # DELETE /cruises/1.json
  def destroy
    @cruise.destroy
    respond_to do |format|
      format.html { redirect_to cruises_url, notice: 'Cruise was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def approve
    if @cruise.update_attribute(:approved, true)
      redirect_to cruise_path(@cruise), notice: 'Cruise has been approved'
    else
      redirect_to cruise_path(@cruise), error: 'Cruise could not be approved'
    end
  end

  def approve_observations
    @cruise = Cruise.find params[:id]
    # FIXME: should return counts of succes/failure, or some other useful information
    @cruise.batch_approve_observations(filter_invalid?)

    redirect_to @cruise, notice: "Approved all valid observations for #{@cruise}"
  end

  private
  def set_current_year
    year = params[:year] || Cruise.order(starts_at: :desc).first.try(:year)
    @current_year = year || Time.now.year
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_cruise
    @cruise = Cruise.find(params[:id])
  end

  def set_observations
    @observations = @cruise.observations.order(observed_at: :desc).accessible_by(current_ability)
    @observations = @observations.where(id: params[:observations].map(&:to_i)) if params[:observations]
    @observations = @observations.page(params[:page]) unless request.format == 'application/zip'
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cruise_params
    params.require(:cruise).permit(:starts_at, :ends_at, :objective, :approved,
                                   :chief_scientist, :captain, :ship,
                                   :primary_observer_id_or_name)
  end

  def set_active_cruise
    @active_cruise = Cruise.where(id: cookies[:current_cruise]).first || Cruise.first
  end

  def after_modify_path
    Rails.application.secrets.icewatch_assist ? root_path : @cruise
  end

  def filter_invalid?
    params[:filter_invalid] == 'false' ? false : true
  end
end
