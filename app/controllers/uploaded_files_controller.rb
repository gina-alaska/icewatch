class UploadedFilesController < ApplicationController
  authorize_resource
  # POST /uploaded_files
  before_action :set_cruise, only: [:create, :new]
  def new
    @uploaded_file = @cruise.uploaded_files.build
  end

  def create
    @uploaded_file = @cruise.uploaded_files.new(uploaded_file_params)

    respond_to do |format|
      if @uploaded_file.save
        ImportFileJob.perform_later(@uploaded_file)
        format.html { redirect_to @cruise, notice: 'Upload has been sumbmitted to background processing for import' }
        format.json { render :show, status: :created, location: @uploaded_file }
      else
        format.html { render :new }
        format.json { render json: @uploaded_file.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def uploaded_file_params
    params.require(:uploaded_file).permit(:file, :hosted_file_url)
  end

  def set_cruise
    @cruise = Cruise.find(params[:cruise_id])
  end
end
