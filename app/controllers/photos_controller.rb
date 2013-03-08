class PhotosController < ApplicationController
  def index
    @cruise = Cruise.where(id: params[:cruise_id]).first
  end
end