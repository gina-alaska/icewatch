class Person
  include Mongoid::Document
  
  embedded_in :observation, inverse_of: :primary_observer

  field :firstname, type: String
  field :lastname, type: String
  
  def first_and_last_name 
    "#{firstname} #{lastname}"
  end
  
  def unknown?
    [firstname,lastname].join.empty?
  end
end