class PhotosController < ApplicationController
  before_action :set_cruise, only: [:index]

  def show
    path = params[:filename]
    full_path = File.join(EXPORT_PATH, "#{path}.#{params[:format]}")

    respond_to do |format|
      format.any { send_file full_path, type: request.format, disposition: :inline }
    end
  end

  def index
    @photos = @cruise.photos
  end

  private
  def set_cruise
    @cruise = Cruise.find(params[:cruise_id])
  end
end