class ChartsController < ApplicationController
  before_action :set_cruise

  def index
  end

  def ice_concentration
  end

  def ice_type
    observed_ice_types = @cruise.grouped_observed_ice_types

    render json: observed_ice_types
  end

  def total_concentration
    concentrations = @cruise.observations.map do |observation|
      [observation.observed_at, observation.ice.total_concentration]
    end
    render json: concentrations
  end

  private

  def set_cruise
    @cruise = Cruise.find(params[:cruise_id])
  end
end