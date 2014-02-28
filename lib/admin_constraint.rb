class AdminConstraint
  def matches? request
    User.where(id: request.session[:current_user_id], admin: true).first || false
  end
end