class Admin::ObservationsController < AdminController
  respond_to :html
  def index
    @observations = Observation.all
    @pending = Observation.pending
    @errors = Observation.has_errors
    
    respond_to do |format|
      if request.xhr?
        format.html { render partial: 'admin/observations/pending', layout: false }
      else
        format.html { render :index }
      end
    end
  end
  
  def import
    @cruise = Cruise.find(params[:cruise_id])
    
    if(@cruise)
      @observations = Observation.from_file(params[:observation].tempfile, content_type: params[:observation].content_type, observation: {cruise_id: params[:cruise_id]})
    end
    
    respond_to do |format|
      if request.xhr?
        format.html {render :import, layout: false }
      else
        format.html
      end
    end
  end
end