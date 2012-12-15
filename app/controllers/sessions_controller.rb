class SessionsController < ApplicationController
  
  def create
    user = User.where(:provider => auth_hash['provider'], 
                      :uid => auth_hash['uid']).first || User.create_with_omniauth(auth_hash)
    session[:user_id] = user.id
    
    flash[:success] = 'Signed in!'
    redirect_to user_url(user)
  end
  
  def destroy
    reset_session
    flash[:success] = 'Signed out!'
    redirect_to root_url
  end
  
  def new
    redirect_to '/auth/google'
  end
  
  def failure
    flash[:error] = "Authentication error: #{params[:message].humanize}"
    redirect_to root_url
  end
end