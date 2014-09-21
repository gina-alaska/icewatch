module GinaAuthentication
  module MembershipModel
    extend ActiveSupport::Concern
    
    included do
      belongs_to :user
      validates :email, presence: true, uniqueness: true
    end
  end
end