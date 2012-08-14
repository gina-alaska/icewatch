module ApplicationHelper
  
  def ymd date
    date.try(:strftime,"%Y-%m-%d") || nil
  end
end
