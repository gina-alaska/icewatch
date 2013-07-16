class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "application"
 
  before_filter :set_year
  before_filter :set_available_years

  
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
  
  protected
  
  def set_year    
    if params[:year]
      @year = Time.utc(params[:year].to_i).beginning_of_year
    else
      #Mongo issue - Doing a count on queries with where clause that return a large number
      # of datasets can cause queries to take multiple seconds. 
      @year = Cruise.desc(:start_date).select{|c| c.observations.exists?}.first.start_date.beginning_of_year
    end
  end
  
  def set_available_years
    cruise = Cruise.only(:start_date).asc(:start_date).first
    unless cruise.nil?
      first_year = cruise.start_date.year
      @available_years = (first_year..Time.zone.now.year).to_a
    end
  end
end
