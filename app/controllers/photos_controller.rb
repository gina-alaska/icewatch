class PhotosController < ApplicationController
  before_action :set_parent

  def show
    path = params[:filename]
    full_path = File.join(EXPORT_PATH, "#{path}.#{params[:format]}")

    respond_to do |format|
      format.any { send_file full_path, type: request.format, disposition: :inline }
    end
  end

  def index
    @photos = @parent.photos.page(params[:page]).per(25)
  end

  def download

  end

  private
  def set_parent
    @cruise = @parent = Cruise.find(params[:cruise_id]) if params[:cruise_id]

    if params[:observation_id]
      @parent = Observation.find(params[:observation_id])
      @cruise = @parent.cruise
    end
  end
end
