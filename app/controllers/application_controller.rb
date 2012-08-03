class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    return nil if session[:user_id].nil?
    
    @current_user ||= User.find(session[:user_id])
  end
  helper_method :current_user
  
  def auth_hash
    request.env['omniauth.auth']
  end

 private  
  def logged_in?
    user = current_user
    unless user && user.approved?
      redirect_to root_url # halts request cycle
    end
  end  
  
end
