class WelcomeController < ApplicationController
  respond_to :html, :json

  before_filter :set_year
  before_filter :set_available_years

  def index
    @cruises = Cruise.asc(:start_date).includes(:observations).between(start_date: [@year,@year.end_of_year]).or.between(end_date: [@year,@year.end_of_year])
  end
  
  private
  def set_year    
    if params[:year]
      @year = Time.zone.new(params[:year].to_i).beginning_of_year
    else
      @year = Time.zone.now.beginning_of_year
    end
  end
  
  def set_available_years
    cruise = Cruise.only(:start_date).asc(:start_date).first
    unless cruise.nil?
      first_year = cruise.start_date.year
      @available_years = (first_year..Time.now.year).to_a
    end
  end
  
end