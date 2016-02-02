class Note < ActiveRecord::Base
  validates :text, length: {maximum: 80}, allow_blank: true
  belongs_to :observation
end
