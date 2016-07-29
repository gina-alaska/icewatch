class Note < ActiveRecord::Base
  include Importable::Note

  validates :text, length: { maximum: 80 }, allow_blank: true
  belongs_to :observation
end
