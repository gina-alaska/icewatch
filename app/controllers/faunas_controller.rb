class FaunasController < ApplicationController
  before_action :set_fauna, only: [:show, :edit, :update, :destroy]

  # GET /faunas
  # GET /faunas.json
  def index
    @faunas = Fauna.all
  end

  # GET /faunas/1
  # GET /faunas/1.json
  def show
  end

  # GET /faunas/new
  def new
    @fauna = Fauna.new
  end

  # GET /faunas/1/edit
  def edit
  end

  # POST /faunas
  # POST /faunas.json
  def create
    @fauna = Fauna.new(fauna_params)

    respond_to do |format|
      if @fauna.save
        format.html { redirect_to @fauna, notice: 'Fauna was successfully created.' }
        format.json { render :show, status: :created, location: @fauna }
      else
        format.html { render :new }
        format.json { render json: @fauna.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /faunas/1
  # PATCH/PUT /faunas/1.json
  def update
    respond_to do |format|
      if @fauna.update(fauna_params)
        format.html { redirect_to @fauna, notice: 'Fauna was successfully updated.' }
        format.json { render :show, status: :ok, location: @fauna }
      else
        format.html { render :edit }
        format.json { render json: @fauna.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /faunas/1
  # DELETE /faunas/1.json
  def destroy
    @fauna.destroy
    respond_to do |format|
      format.html { redirect_to faunas_url, notice: 'Fauna was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fauna
      @fauna = Fauna.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fauna_params
      params.require(:fauna).permit(:name, :count, :observation_id)
    end
end
