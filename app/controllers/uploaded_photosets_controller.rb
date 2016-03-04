class UploadedPhotosetsController < ApplicationController
  authorize_resource
  # POST /uploaded_photosets
  before_action :set_cruise, only: [:create, :new]
  def new
    @uploaded_photoset = @cruise.uploaded_photosets.build
  end

  def create
    @uploaded_photoset = @cruise.uploaded_photosets.new(uploaded_photoset_params)

    respond_to do |format|
      if @uploaded_photoset.save
        ImportPhotosetJob.perform_later(@uploaded_photoset)
        format.html { redirect_to @cruise, notice: 'Upload has been sumbmitted to background processing for import' }
        format.json { render :show, status: :created, location: @uploaded_photoset }
      else
        format.html { render :new }
        format.json { render json: @uploaded_photoset.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def uploaded_photoset_params
    params.require(:uploaded_photoset).permit(:file)
  end

  def set_cruise
    @cruise = Cruise.find(params[:cruise_id])
  end
end
