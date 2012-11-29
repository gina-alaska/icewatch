class AdminController < ApplicationController
  before_filter :is_admin

  layout "admin"

private  
  def is_admin
    user = current_user
    unless user && user.admin?
      redirect_to root_url # halts request cycle
    end
  end
end