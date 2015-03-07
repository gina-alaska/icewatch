class ApplicationController < ActionController::Base
  include GinaAuthentication::AppHelpers

  before_action :set_variant_type
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def set_variant_type
    request.variant = :assist if Rails.application.secrets.icewatch_assist
    request.variant = :assist if RUBY_PLATFORM == 'java'
  end

  rescue_from CanCan::AccessDenied do |exception|
    session[:redirect_back_to] = request.original_url
    redirect_to root_url
  end
end
