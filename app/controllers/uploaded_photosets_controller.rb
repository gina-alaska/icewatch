class UploadedPhotosetsController < ApplicationController
  # POST /uploaded_photosets
  def create
    @cruise = Cruise.find(params[:cruise_id])
    @uploaded_photoset = @cruise.uploaded_photosets.new(uploaded_photoset_params)

    respond_to do |format|
      if @uploaded_photoset.save
        format.html { redirect_to @cruise, notice: 'Uploaded photoset was successfully created.' }
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
end
