class ApplicationController < ActionController::Base
  include GinaAuthentication::AppHelpers

  before_action :set_variant_type
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def set_variant_type
    request.vairant :assist if ENV['ICEWATCH_ASSIST']
  end
end
