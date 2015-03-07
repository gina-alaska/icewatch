module ApplicationHelper
  def assist?
    Rails.application.secrets.icewatch_assist
  end
end
