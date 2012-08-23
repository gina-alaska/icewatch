class UsersController < ApplicationController
  before_filter :check_user
  
  def index
    redirect_to root_url
  end
    
  def show
    @user = User.find(params[:id])
    @cruises = @user.cruises
    respond_to do |format|
      format.html 
    end
  end
  
  def edit
    @user = User.find(params[:id])
  
    respond_to do |format|
      format.html
    end

  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(get_params)
      redirect_to user_url(@user)
    else
      render action: :edit
    end
  end
  
  
private
  def check_user
    unless User.find(params[:id]) == current_user
      redirect_to root_url
    end
  end
  
  def get_params
    params[:user]
  end
end