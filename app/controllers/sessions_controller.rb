class SessionsController < ApplicationController
  protect_from_forgery :except => [:create, :failure]
  include GinaAuthentication::Sessions

  # def new
  #   session[:redirect_back_to] = request.referer if session[:redirect_back_to].nil?
  #   redirect_to '/auth/google/callback'
  # end
end
