class Admin::LookupsController < AdminController
  before_filter :load_lookups
  
  def index
  
  end
  
  def show
    @lookups = load_lookups
  end
  
  private
  def load_lookups 
    params[:id].constantize.asc(:code) if (LOOKUP_TABLES.include? params[:id] )
  end
end