class Admin::LookupsController < AdminController
  before_filter :load_lookups
  
  def index
    
  end
  
  def show
  end


  private
  def load_lookups 
    @lookups ||= Dir.glob(Rails.root.join("app","models","*_lookup.rb")).collect{|m| ::File.basename(m,".rb").camelcase.constantize}
  end
end