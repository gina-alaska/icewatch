module ApplicationHelper
  def login_helper
    #if current_user.logged_in?
      #"Logout"
    #elsif currrent_user.new_user?
      #"Register"
    #else
    link_to "Login", "#"
  end


  def current_year
    '2014'
  end
end
