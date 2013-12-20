class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:create]
  
  def create
    unless @auth = Authorization.find_from_hash(auth_hash)
      @auth = Authorization.create_from_hash(auth_hash, current_user)
    end
    
    self.current_user = @auth.user

    flash[:success] = 'Signed in!'
    redirect_to user_url(current_user.id)
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