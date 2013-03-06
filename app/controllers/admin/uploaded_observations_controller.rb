class Admin::UploadedObservationsController < AdminController
  def index
    @uploaded_observations = UploadedObservation.all
  end
  
  def show
    @uploaded_observation = UploadedObservation.where(id: params[:id]).first
    
    respond_to do |format|
      format.html {render layout: false if request.xhr?}
    end
  end
  
  def create
    @observation = UploadedObservation.new(uploaded_observation_params)
    
    if @observation.save
      ImportWorker.perform_async(@observation.id)
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
  
  def update
    @uploaded_observation = UploadedObservation.where(id: params[:id]).first
    @uploaded_observation.import_errors = []

    if(@uploaded_observation.update_attributes(uploaded_observation_params))
      ImportWorker.perform_async(@uploaded_observation.id)
      respond_to do |format|
        format.html
        format.json {render json: {success: true}}
      end
    else
      respond_to do |format|
        format.html
        format.json {render json: {success: false}}
      end
    end
  end
  
  def destroy
    @uploaded_observation = UploadedObservation.where(id: params[:id]).first
    
    #TODO: Clear out any Sidekiq jobs
    if(@uploaded_observation.destroy)
      redirect_to admin_uploaded_observations_path
    else
      render :show
    end
  end
  
  private
  def uploaded_observation_params
    params[:uploaded_observation] || {}
  end
end