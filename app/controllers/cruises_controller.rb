class CruisesController < ApplicationController
  before_action :set_cruise, only: [:show, :edit, :update, :destroy]
  before_action :set_active_cruise, only: [:index, :show]

  # GET /cruises
  # GET /cruises.json
  def index
    @cruises = Cruise.all
  end

  # GET /cruises/1
  # GET /cruises/1.json
  def show
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
        format.html { redirect_to @cruise, notice: 'Cruise was successfully created.' }
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
      if @cruise.update(cruise_params)
        format.html { redirect_to @cruise, notice: 'Cruise was successfully updated.' }
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def cruise_params
      params.require(:cruise).permit(:starts_at, :ends_at, :objective, :approved)
    end

    def set_active_cruise
      @active_cruise = Cruise.where(id:cookies[:current_cruise]).first || Cruise.first
    end
end
