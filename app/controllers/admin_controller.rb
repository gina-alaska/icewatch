class AdminController < ApplicationController
  before_filter :is_admin

  layout "admin"

private  
  def is_admin
    if !logged_in?
      redirect_to login_url
    elsif !current_user.admin?
      flash[:error] = 'Not authorized to view this page'
      redirect_to root_url # halts request cycle
    end
  end
end