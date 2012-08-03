class SessionsController < ApplicationController
  def create
    @user = User.find_with_omniauth(auth_hash)
    @user = User.create_with_omniauth(auth_hash) if @user.nil?

    session[:user_id] = @user.id

    redirect_to '/'
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end
end