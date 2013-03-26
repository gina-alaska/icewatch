class Cloud 
  include Mongoid::Document
  include AssistShared::Validations::Cloud
  include AssistShared::Validations
  include AssistShared::CSV::Cloud

  field :cover, type: Integer
  field :height, type: Integer
  field :cloud_type, type: String
  
  embedded_in :eteorology

  belongs_to :cloud_lookup
  
  def as_json opts={}
    data = super
    
    data = data.inject(Hash.new) do |h,(k,v)|
      key = k.gsub( /lookup_id$/, "lookup_code")
      
      h[key] = v
      
      h
    end
    
  end
end