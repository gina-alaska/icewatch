class ObservationsController < ApplicationController
  respond_to :html, :json

  def show
    @observation = observation.where(id: params[:id]).first
  end

  def import
    @cruise = cruise.where(id: params[:cruise_id], user_id: current_user).first

    if @cruise.nil?
      flash[:error] = "You don't have permission to do that"
      redirect_to :root_url
    end

    logger.info(params[:observation].inspect)

    @imports = ImportObservation.new(file: params[:observation], cruise_id: @cruise.id)

    if @imports.save
      respond_to do |format|
          format.html { redirect_to :back, flash: flash }
      end
    else
      logger.info(@imports.errors.messages.inspect)
      respond_to do |format|
        format.html
      end
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
