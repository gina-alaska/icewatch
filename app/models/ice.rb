class Ice
  include Mongoid::Document
  
  field :total_concentration, type: Numeric
  
  embedded_in :observation
  
  
end
