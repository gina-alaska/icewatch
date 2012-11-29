class ObservationsController < ApplicationController
  respond_to :html, :json
      
  def import
    @cruise = Cruise.where(id: params[:cruise_id], user_id: current_user).first
    
    if @cruise.nil?
      flash[:error] = "You don't have permission to do that"
      redirect_to :root_url
    end
    
    @imported = [];
    @errors = [];
    ImportObservation.from_file(params[:observation].tempfile, import_observation_params).each do |import|
      begin
        observation = import.to_observation
        logger.info(observation.inspect)
        if observation.save
          @imported << observation
        else
          @imported << import
          import.save
        end
      rescue ImportObservation::InvalidLookupException
        @errors << import
        import.save
      end
    end
    
    if @imported.any?
      flash[:notice] = "#{@imported.count} records imported"
    end
    if @errors.any?
      flash[:error] = "#{@errors.count} records had errors"
    end
    flash[:doom] = "Something went wrong"
    
    respond_to do |format|
        format.html { redirect_to :back, flash: flash }
    end
  end
  
private
  def import_observation_params
    {
      content_type: params[:observation].content_type,
      cruise_id: params[:cruise_id],
      filename: params[:observation].original_filename
    }
  end  
end
