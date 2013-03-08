module ApplicationHelper
  
  def ymd date
    date.try(:strftime,"%Y-%m-%d") || nil
  end

  def get_legend layer
    url = URI.parse("http://shire.gina.alaska.edu/?SERVICE=legend&LAYERS=#{layer}")
    response = Net::HTTP.get_response(url)
    
    if response.code == 200
      response.body.html_safe
    else
      ""
    end
  end

end
