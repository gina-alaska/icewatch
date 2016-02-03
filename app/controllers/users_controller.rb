class UsersController < ApplicationController
  include GinaAuthentication::Users
  before_action :setup_user, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    @users = User.order('lower(name) ASC')
  end

  def show

  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to users_path }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    if @user.destroy
      redirect_to(users_path, notice: "User #{@user} deleted.")
    else
      redirect_to(users_path, notice: "Unable to delete #{@user}.")
    end
  end

  private
  def setup_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:role)
  end
end
