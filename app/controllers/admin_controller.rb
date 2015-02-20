class AdminController < ApplicationController
  before_action :is_admin?

  layout 'admin'

  private

  def is_admin?
    if !signed_in?
      redirect_to login_url
    elsif !current_user.has_role?(:admin)
      flash[:error] = 'You are not authorized to view that page'
      redirect_to root_url
    end
  end
end
