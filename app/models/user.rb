class User < ActiveRecord::Base
  include GinaAuthentication::UserModel
  ROLES = %w{admin manager member guest}

  def has_role?(base)
    ROLES.index(base.to_s) >= ROLES.index(role)
  end
end
