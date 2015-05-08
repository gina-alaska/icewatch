class UsersController < ApplicationController
  include GinaAuthentication::Users
  before_action :setup_user, only: [:show]
  def show

  end

  private
  def setup_user
    @user = User.find(params[:id])
  end
end
