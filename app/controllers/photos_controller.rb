class PhotosController < ApplicationController
  before_action :set_cruise

  def show
    path = params[:filename]
    full_path = File.join(EXPORT_PATH, "#{path}.#{params[:format]}")

    respond_to do |format|
      format.any { send_file full_path, type: request.format, disposition: :inline }
    end
  end

  def index
    @photos = @cruise.photos.page(params[:page]).per(25)
  end

  def download

  end

  private
  def set_cruise
    @cruise = Cruise.find(params[:cruise_id])
  end
end