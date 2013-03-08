module ApplicationHelper
  
  def ymd date
    date.try(:strftime,"%Y-%m-%d") || nil
  end

  def get_legend layer
    url = URI.parse("http://shire.gina.alaska.edu/?SERVICE=legend&LAYERS=#{layer}")
    Net::HTTP.get_response(url).body.html_safe
  end

end
