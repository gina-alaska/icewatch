module WelcomeHelper
  def list_item_for_year year
    if year == @year.year
      css_class = 'active'
    else
      css_class = ''
    end
    "<li #{css_class}>#{link_to(year, root_url(year: year))}</li>".html_safe
  end
end