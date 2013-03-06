class Admin::PhotosController < AdminController
  def create
    @photo = UploadedPhoto.new(uploaded_photo_params)
    
    if @photo.save
      PhotoWorker.perform_async(@photo.id)
      respond_to do |format|
        format.html 
        format.json { render json: {success: true}}
      end
    else
      respond_to do |format|
        format.html
        format.json {render json: {success: false}}
      end
    end
  end
  
  private
  def uploaded_photo_params
    params[:photo] || {}
  end
end
