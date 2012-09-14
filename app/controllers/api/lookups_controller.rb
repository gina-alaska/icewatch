class Api::LookupsController < ApiController
  respond_to :json
  
  def index
    @lookups = lookup_tables.inject(Hash.new) do |h, lookup|
      h[lookup] = lookup.chomp('s').camelcase.constantize.all
      h
    end

  
    respond_to do |format|
      format.json { render json: @lookups, except: [:_id, :version] }
    end
  end
  
  def show
   # @lookups = "#{params[:id].camelcase}Lookup".constantize.all
    
  end
  
  private
  def lookup_tables
    Mongoid.default_session.collections.collect(&:name).select{|name| name =~ /lookups$/}
  end
  
end