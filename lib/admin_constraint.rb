class AdminConstraint
  def matches? request
    User.where(id: request.session[:user_id], admin: true).first || false
  end
end