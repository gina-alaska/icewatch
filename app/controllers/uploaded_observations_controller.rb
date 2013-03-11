class UploadedObservationsController < ApplicationController
  before_filter :verify_user
  
  def index
    @uploaded_observations = UploadedObservation.where(user_id: current_user.id)
    
    render layout: !request.xhr? 
  end

  def show
    @uploaded_observation = UploadedObservation.where(id: params[:id], user_id: current_user.id).first

    if @uploaded_observation.nil?
      redirect_to users_path(current_user)
    else
      render layout: !request.xhr?
    end
  end

  def create
    @observation = UploadedObservation.new(uploaded_observation_params)
    @observation.user = current_user
    if @observation.save
      ImportWorker.perform_async(@observation.id)
      respond_to do |format|
        format.html 
        format.json { render json: {success: true}}
      end
    else
      respond_to do |format|
        format.html
        format.json {render json: {success: false}}
      end
    end
  end

  def update
    @uploaded_observation = UploadedObservation.where(id: params[:id]).first
    @uploaded_observation.import_errors = []

    if(@uploaded_observation.update_attributes(uploaded_observation_params))
      ImportWorker.perform_async(@uploaded_observation.id)
      respond_to do |format|
        format.html
        format.json {render json: {success: true}}
      end
    else
      respond_to do |format|
        format.html
        format.json {render json: {success: false}}
      end
    end
  end

  def destroy
    @uploaded_observation = UploadedObservation.where(id: params[:id]).first

    if(@uploaded_observation.destroy)
      redirect_to user_path(current_user)
    else
      render user_path(current_user)
    end
  end

  private
  def uploaded_observation_params
    params[:uploaded_observation] || {}
  end
  
  def verify_user
    unless logged_in? and current_user == User.where(id: params[:user_id]).first
      redirect_to root_url
    end
  end
end