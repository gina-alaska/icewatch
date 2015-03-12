class User < ActiveRecord::Base
  include GinaAuthentication::UserModel
  ROLES = %w(admin manager member guest)
  validates :role, presence: true, inclusion: { in: ROLES }

  has_and_belongs_to_many :cruises

  def has_role?(base)
    ROLES.index(base.to_s) >= ROLES.index(role)
  end
end
