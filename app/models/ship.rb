class Ship
  include Mongoid::Document
  field :heading, type: Integer
  field :power, type: Integer
  field :speed, type: Integer

  belongs_to :ship_activity_lookup
  
  embedded_in :observation
end
