class Note
  include Mongoid::Document
  field :text, type: String

  embedded_in :observation
  validates :text, length: {maximum: 80}
end
