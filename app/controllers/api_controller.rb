class ApiController < ApplicationController
  layout false
  
  before_filter :set_year
  
  private
  def set_year    
    if params[:year]
      @year = Time.utc(params[:year].to_i)
    else
      @year = Time.zone.now.beginning_of_year
    end
  end

end