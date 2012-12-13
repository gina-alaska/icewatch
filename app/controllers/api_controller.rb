class ApiController < ApplicationController
  layout false
  
  before_filter :set_year
  
  private
  def set_year    
    if params[:year]
      @year = Time.new(params[:year].to_i)
    else
      @year = Time.now
    end
  end

end