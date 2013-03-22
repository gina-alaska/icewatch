module ApplicationHelper
  
  def ymd date
    date.try(:strftime,"%Y-%m-%d") || nil
  end

  def get_legend layer
    url = URI.parse("http://shire.gina.alaska.edu/?SERVICE=legend&LAYERS=#{layer}")
    response = Net::HTTP.get_response(url)
    
    if response.code.to_i == 200
      response.body.html_safe
    else
      ""
    end
  end
  
  def link_to_assist text="ASSIST", opts={}
    link_to text, "/ASSIST_20130131.zip", class: opts[:class]
  end

  def editable? cruise
    logged_in? and (current_user.admin? or current_user == cruise.user) 
  end
end
