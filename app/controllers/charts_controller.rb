class ChartsController < ApplicationController
  before_action :set_cruise

  def ice_concentration

  end

  def ice_type
    ice_types = IceObservation.where(observation_id: @cruise.observations)

    render json: ice_types.group(:partial_concentration).sum(:count)
  end

  private

  def set_cruise
    @cruise = Cruise.find(params[:cruise_id])
  end
end