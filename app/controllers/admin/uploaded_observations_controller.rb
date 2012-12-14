class Admin::UploadedObservationsController < AdminController
  def create
    @cruise = Cruise.where(id: params[:cruise_id]).first
    @observation = UploadedObservation.new(uploaded_observation_params)
    @observation.cruise = @cruise
    
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
  
  def uploaded_observation_params
    params[:uploaded_observation] || {}
  end
end