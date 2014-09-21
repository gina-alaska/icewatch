class Membership < ActiveRecord::Base
  include GinaAuthentication::MembershipModel
end
