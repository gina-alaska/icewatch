class ObservationsController < ApplicationController
  respond_to :html, :json, :geojson
  
  def index
    @observations = Observation.where(:obs_datetime.lt => Date.parse("2010-1-1")).asc(:obs_datetime).all
    graph = params.delete(:graph)
    
    
    
    respond_to do |format|
      format.geojson { render :json =>  @observations.collect(&:to_geojson) }
      format.json { render json: @observations } #[{ name: "Total Concentration", data: @observations.collect(&:to_rickshaw) }] }
     # format.d3 { render json: { data: @observations.collect(&:to_rickshaw)}}
    end
    
  end
  
  def import
    cruise = Cruise.find(params[:cruise_id])
    
    if(cruise)
      #Figure out what kind of data this is(json/csv/zip)
      #data.each do |obs|
        # observation = Observation.new(obs)
        # observation.is_valid = observation.valid?
        # observation.save(validate: false)
      # end
    end
    
    respond_to do |format|
      if request.xhr?
        format.json {render json: {success: true, cruise: cruise}, layout: false}
      else
        format.json {render json: {success: true}, layout: false}
      end
    end
  end
end
