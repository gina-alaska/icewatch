class ObservationsController < ApplicationController
  respond_to :html, :json
      
  def import
    @cruise = Cruise.where(id: params[:cruise_id], user_id: current_user).first
    
    if @cruise.nil?
      flash[:error] = "You don't have permission to do that"
      redirect_to :root_url
    end
    
    @results = Hash.new(0)
    ImportObservation.from_file(params[:observation].tempfile, import_observation_params).each do |import|
      begin
        observation = import.to_observation

        if observation.save
          @results[:valid] += 1
        else
          @results[:errors] += 1
          import.save
        end
      rescue InvalidLookupException
        @results[:invalid] += 1
        import.save
      end
    end
    
    respond_to do |format|
      if request.xhr?
        format.html {render @cruise, layout: false }
        format.json {render json: @results, layout: false}
      else
        format.html { redirect_to cruise_url(@cruise) }
      end
    end
  end
private
  def import_observation_params
    {
      content_type: params[:observation].content_type,
      cruise_id: params[:cruise_id]
    }
  end  
end
