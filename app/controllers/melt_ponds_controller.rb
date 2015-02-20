class MeltPondsController < ApplicationController
  before_action :set_melt_pond, only: [:show, :edit, :update, :destroy]

  # GET /melt_ponds
  # GET /melt_ponds.json
  def index
    @melt_ponds = MeltPond.all
  end

  # GET /melt_ponds/1
  # GET /melt_ponds/1.json
  def show
  end

  # GET /melt_ponds/new
  def new
    @melt_pond = MeltPond.new
  end

  # GET /melt_ponds/1/edit
  def edit
  end

  # POST /melt_ponds
  # POST /melt_ponds.json
  def create
    @melt_pond = MeltPond.new(melt_pond_params)

    respond_to do |format|
      if @melt_pond.save
        format.html { redirect_to @melt_pond, notice: 'Melt pond was successfully created.' }
        format.json { render :show, status: :created, location: @melt_pond }
      else
        format.html { render :new }
        format.json { render json: @melt_pond.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /melt_ponds/1
  # PATCH/PUT /melt_ponds/1.json
  def update
    respond_to do |format|
      if @melt_pond.update(melt_pond_params)
        format.html { redirect_to @melt_pond, notice: 'Melt pond was successfully updated.' }
        format.json { render :show, status: :ok, location: @melt_pond }
      else
        format.html { render :edit }
        format.json { render json: @melt_pond.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /melt_ponds/1
  # DELETE /melt_ponds/1.json
  def destroy
    @melt_pond.destroy
    respond_to do |format|
      format.html { redirect_to melt_ponds_url, notice: 'Melt pond was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_melt_pond
    @melt_pond = MeltPond.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def melt_pond_params
    params.require(:melt_pond).permit(:ice_observation_id, :max_depth_lookup_id, :surface_lookup_id, :pattern_lookup_id, :bottom_type_lookup_id, :surface_coverage, :freeboard, :dried_ice, :rotten_ice)
  end
end
