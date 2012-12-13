class WelcomeController < ApplicationController
  respond_to :html, :json

  before_filter :set_year
  before_filter :set_available_years

  def index
    @cruises = Cruise.asc(:start_date).includes(:observations).between(start_date: [@year,@year+1.year]).or.between(end_date: [@year,@year+1.year])
  end
  
  private
  def set_year    
    if params[:year]
      @year = Time.new(params[:year].to_i)
    else
      @year = Time.now
    end
  end
  
  def set_available_years
    first_year = Cruise.only(:start_date).asc(:start_date).first.start_date.year
    @available_years = (first_year..Time.now.year).to_a
  end
  
end