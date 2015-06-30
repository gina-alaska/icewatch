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
    @available_years = Cruise.accessible_by(current_ability).start_dates.group_by{|s| s.year }
    if Rails.application.secrets.icewatch_assist && @cruises.empty?
      redirect_to new_cruise_path
    end
  end

  # GET /cruises/1
  # GET /cruises/1.json
  def show
    Rails.logger.info( request.format )
    if @cruise.approved? or can?(:read, @cruise)
      respond_to do |format|
        format.html
        format.geojson
        format.json
        format.csv
        format.zip do
          generate_zip !!params[:photos]
          File.open(File.join(@cruise.export_path, "#{@cruise}.zip"), 'rb') do |f|
            send_data f.read, filename: "#{@cruise}.zip"
          end
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
    @cruise.batch_approve_observations(filter_invalid?)

    redirect_to @cruise
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
    @observations = @observations.where(id: params[:observations]) if params[:observations]
    @observations.page(params[:page]) unless request.format == 'application/zip'
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

  def generate_zip(include_photos = false)
    FileUtils.mkdir_p @cruise.export_path unless File.exist? @cruise.export_path
    export_file = File.join(@cruise.export_path, "#{@cruise}.zip")
    FileUtils.remove(export_file) if File.exist?(export_file)

    Zip::File.open(export_file, Zip::File::CREATE) do |zipfile|
      zipfile.get_output_stream 'METADATA' do |f|
        f.write @cruise.metadata.to_yaml
      end

      #Ugly hack to get around paging
      @observations.each do |observation|
        # %w(csv json).each do |format|
        #   if File.exist?(observation.export_file(format))
        #     obs_path = File.join(observation.to_s, File.basename(observation.export_file(format)))
        #     zipfile.add obs_path, observation.export_file(format)
        #   end
        # end
        if include_photos
          observation.photos.each do |photo|
            next unless File.exists?(photo.file_path)
            path = File.join(observation.to_s, File.basename(photo.file_path))
            zipfile.add path, photo.file_path
          end
        end
      end

      zipfile.get_output_stream("#{@cruise}.json") do |f|
        f.write JSON.pretty_generate(JSON.parse(@cruise.render_to_string))
      end
      zipfile.get_output_stream("#{@cruise}.csv") do |f|
        f << Observation.csv_headers + "\n"
        @observations.each do |o|
          f << o.as_csv.to_csv
        end
      end
    end
  end
end
