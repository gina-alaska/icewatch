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
  
  def edit  
    @import = ImportObservation.where(id: params[:id]).first
    begin
      @observation = @import.to_observation
      @observation.valid?
    rescue ImportObservation::InvalidLookupException
    end
  end
  
  def update
    @import = ImportObservation.where(id: params[:id]).first
    @import.update_attributes(observation_params)
    begin
      @observation = @import.to_observation
      if @observation.save
        @import.destroy
        flash[:notice] = "Observation successfully imported"
        redirect_to admin_imports_url
      else
        render :edit
      end
    end
  end
  
  def destroy
    @import = ImportObservation.where(id: params[:id]).first
    
    @import.destroy
    
    redirect_to admin_imports_url
  end
  
  private
  def observation_params
    params[:observation] || {}
  end
end