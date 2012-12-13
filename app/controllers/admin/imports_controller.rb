class Admin::ImportsController < AdminController
  def index
    @observations = ImportObservation.all
  end
  
  def show
    @import = ImportObservation.where(id: params[:id]).first
    begin
      @observation = @import.to_observation
      @observation.valid?
    rescue ImportObservation::InvalidLookupException
    end
  end
  
  def new
    @observation = UploadedObservation.new(uploaded_observation_params)
    if @observation.save
      ImportWorker.async_perform(@observation.id)
      respond_to do |format|
        format.html 
        format.json { render {success: true}}
      end
    else
      respond_to do |format|
        format.html
        format.json {render {success: false}}
      end
    end
  end
  
  def edit  
    @import = ImportObservation.where(id: params[:id]).first
    begin
      @observation = @import.to_observation
      @observation.valid?
    rescue ImportObservation::InvalidLookupException => ex
      flash[:error] = "#{ex.message}. Import is not possible at this time."
    end
  end
  
  def update
    @import = ImportObservation.where(id: params[:id]).first
    @import.update_attributes(observation_params)
    @observations = ImportObservation.all
    begin
      @observation = @import.to_observation
      if @observation.save
        @import.destroy
        flash[:notice] = "Observation successfully imported"
        render :index
      else
        flash[:error] = "There was an error importing the observation"
        render :edit
      end
    end
  end
  
  def destroy
    @import = ImportObservation.where(id: params[:id]).first
    @observations = ImportObservation.all
    @import.destroy
    
    #redirect_to admin_imports_url
    flash[:notice] = "Observation has been permanently deleted"
    render :index
  end
  
  private
  def observation_params
    params[:import] || {}
  end
  
  def uploaded_observation_params
    params[:import] || {}
  end
end