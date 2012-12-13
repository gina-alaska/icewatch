class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "application"
  
  
  def current_user
    @current_user ||= User.where(id: session[:user_id]).first || User.new
  end
  
  def auth_hash
    request.env['omniauth.auth']
  end

  def logged_in?
    !current_user.guest?
  end
  
  def user_approved?
    logged_in? and current_user.approved?
  end
  
  helper_method :current_user, :logged_in?, :user_approved?
end
