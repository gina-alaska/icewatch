class User < ActiveRecord::Base
  include GinaAuthentication::UserModel
end
