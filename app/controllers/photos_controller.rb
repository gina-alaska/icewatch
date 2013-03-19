class PhotosController < ApplicationController
  def index
    @cruise = Cruise.where(id: params[:cruise_id]).first
  end
  
  def edit
    @photo = Photo.where(id: params[:id]).first
  end
  
  def update
    @photo = Photo.where(id: params[:id]).first
    
    if @photo.update_attributes(photo_params)
      redirect_to photo_cruise_path(@photo.cruise) 
    else
      render :edit
    end
  end
  
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
  def photo_params
    params[:photo]
  end
end