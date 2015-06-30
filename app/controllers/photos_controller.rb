class PhotosController < ApplicationController
  def show
    path = params[:filename]
    full_path = File.join(EXPORT_PATH, "#{path}.#{request.format.to_sym}")

    respond_to do |format|
      format.any { send_file full_path, type: request.format, disposition: :inline }
    end

  end
end