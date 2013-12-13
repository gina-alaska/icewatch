class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "application"
 
  before_filter :set_year
  before_filter :set_available_years
  before_filter :set_development
    
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
  
  def admin?
    logged_in? and current_user.admin?
  end

  def cruise
    admin? ? Cruise.unscoped : Cruise
  end
  
  def observation
    admin? ? Observation.unscoped : Observation
  end

  def current_environment
    cookies[:icewatch_environment] || "Live"
  end
  
  helper_method :current_user, :logged_in?, :user_approved?, :admin?, :current_environment
  
  protected
  
  def set_year    
    if params[:year]
      @year = Time.utc(params[:year].to_i).beginning_of_year
    else
      #Mongo issue - Doing a count on queries with where clause that return a large number
      # of datasets can cause queries to take multiple seconds.
      #Find the first cruise with an observation 
      cruise = Cruise.desc(:start_date).select{|c| c.observations.exists?}.first
      #Find the first cruse if there are no (approved) observations
      cruise ||= Cruise.desc(:start_date).first
      #Set the year to the beginning of the cruise start year, or current year if cruise is still nil
      @year = cruise.nil? ? Time.now.utc.beginning_of_year : cruise.start_date.beginning_of_year
    end
  end
  
  def set_available_years
    cruise = Cruise.only(:start_date).asc(:start_date).first
    unless cruise.nil?
      first_year = cruise.start_date.year
      @available_years = (first_year..Time.zone.now.year).to_a
    end
  end
  
  def set_development
    cookies[:icewatch_environment] = "Development" if params[:BETA].present?
  end
end
