class AdminController < ApplicationController
  before_filter :is_admin

  layout :set_layout

private  
  def is_admin
    user = current_user
    unless user && user.admin?
      redirect_to root_url # halts request cycle
    end
  end
  private
  def set_layout
    if request.headers['X-PJAX']
      false
    else
      "admin"
    end
  end
  

end