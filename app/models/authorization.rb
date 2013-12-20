class Authorization
  include Mongoid::Document

  belongs_to :user

  field :provider, :type => String
  field :uid, :type => String
  
  attr_accessible :provider, :uid, :user_id, :user

  validates_presence_of :user_id, :uid, :provider
  validates_uniqueness_of :uid, scope: :provider

  def guest?
    self.new_record?
  end
  
  def self.find_from_hash(hash)
    auth = where(provider: hash['provider'], uid: hash['uid']).first
    if auth.try(:user).nil?
      auth.try(:destroy)
      return nil
    end
    
    auth
  end
  
  def self.create_from_hash(hash, user=nil)
    if user.nil? or user.new_record?
      user = User.create_from_hash!(hash)
      user ||= User.where(email: hash['info']['email']).first
    end
    Authorization.create(user: user, uid: hash['uid'], provider: hash['provider'])
  end  
end
