module GinaAuthentication
  module UserModel
    extend ActiveSupport::Concern

    included do
      has_many :authorizations, dependent: :destroy
      has_one :membership

      validates :email, presence: true, uniqueness: true
    end

    def update_from_hash!(hash)
      update_attributes(self.class.params_from_hash(hash))

      # attempt to associate with membership
      if membership.nil?
        membership = Membership.where(email: email).first
        self.membership = membership unless membership.nil?
      end
    end

    def update_credentials(hash)
      update_attributes(token: hash['token'],
                        expires_at: hash['expires_at'])
    end

    def clear_credentials
      # update_attributes({ token: nil, refresh_token: nil, expires_at: nil })
    end

    def member?
      !membership.nil?
    end

    def to_s
      name
    end

    module ClassMethods
      def create_from_hash!(hash)
        user = where(params_from_hash(hash)).first_or_create

        # attempt to associate with membership
        membership = Membership.where(email: user.email).first
        user.membership = membership unless membership.nil?

        user
      end

      def params_from_hash(hash)
        info = {
          name: hash['info']['name'],
          email: hash['info']['email']
        }
        info
      end
    end
  end
end
