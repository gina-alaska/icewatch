class Comment < ActiveRecord::Base
  belongs_to :observation
  belongs_to :person

  validates_presence_of :person_id

  attr_writer :person_id_or_name
  before_validation :resolve_person

  def resolve_person
    if @person_id_or_name.present?
      self.person = Person.find_or_create_by_id_or_name(@person_id_or_name)
    end
  end

  def person_id_or_name
    self.person.try(:id)
  end
end
