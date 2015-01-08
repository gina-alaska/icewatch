class CruisesController < ApplicationController
  before_action :set_cruise, only: [:show, :edit, :update, :destroy]
  before_action :set_active_cruise, only: [:index, :show]
  before_action :set_observations, only: [:show]

  respond_to :geojson, :json, :csv, :zip
  # GET /cruises
  # GET /cruises.json
  def index
    @cruises = Cruise.all
    if Rails.application.secrets.icewatch_assist and @cruises.empty?
      redirect_to new_cruise_path
    end
  end

  # GET /cruises/1
  # GET /cruises/1.json
  def show
    respond_to do |format|
      format.html
      format.geojson
      format.json
      format.csv
      format.zip do
        generate_zip
        File.open(File.join(@cruise.export_path, "#{@cruise.to_s}.zip"), 'rb') do |f|
          send_data f.read, filename: "#{@cruise.to_s}.zip"
        end
      end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cruise
      @cruise = Cruise.find(params[:id])
    end

    def set_observations
      @observations = @cruise.observations
      if params[:observations]
        @observations = @observations.where(id: params[:observations])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cruise_params
      params.require(:cruise).permit(:starts_at, :ends_at, :objective, :approved,
        :chief_scientist, :captain, :primary_observer, :ship)
    end

    def set_active_cruise
      @active_cruise = Cruise.where(id:cookies[:current_cruise]).first || Cruise.first
    end

    def after_modify_path
      Rails.application.secrets.icewatch_assist ? root_path : @cruise
    end

    def generate_zip params={}
      FileUtils.mkdir_p @cruise.export_path unless File.exists? @cruise.export_path
      export_file = File.join(@cruise.export_path, "#{@cruise.to_s}.zip")
      FileUtils.remove(export_file) if File.exists?(export_file)

      Zip::File.open(export_file, Zip::File::CREATE) do |zipfile|
        zipfile.get_output_stream "METADATA" do |f|
          f.write @cruise.metadata.to_yaml
        end

        @observations.each do |observation|
          %w{csv json}.each do |format|
            if File.exists?(observation.export_file(format))
              obs_path = File.join(observation.to_s, File.basename(observation.export_file(format)))
              zipfile.add obs_path, observation.export_file(format)
            end
          end
        end

        zipfile.get_output_stream("#{@cruise.to_s}.json") do |f|
          f.write JSON.pretty_generate(JSON.parse(@cruise.render_to_string))
        end
        zipfile.get_output_stream("#{@cruise.to_s}.csv") do |f|
          f << Observation.csv_headers + "\n"
          @observations.each do |o|
            f << o.as_csv.to_csv
          end
        end
      end

    end

end
