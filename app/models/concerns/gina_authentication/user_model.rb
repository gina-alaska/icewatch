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
      if self.membership.nil?
        membership = Membership.where(email: self.email).first
        self.membership = membership unless membership.nil?
      end
    end

    def update_credentials(hash)
      update_attributes({
        token: hash['token'],
        expires_at: hash['expires_at']
      })
    end

    def clear_credentials
      # update_attributes({ token: nil, refresh_token: nil, expires_at: nil })
    end

    def member?
      !self.membership.nil?
    end

    def to_s
      self.name
    end

    module ClassMethods
      def create_from_hash!(hash)
        user = create(params_from_hash(hash))

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
        info.merge!({ avatar: hash['info']['image'] }) unless hash['info']['image'].blank?
        info
      end
    end
  end
end