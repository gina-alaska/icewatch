class Authorization < ActiveRecord::Base
  include GinaAuthentication::AuthorizationModel
end
