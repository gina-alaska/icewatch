class User
  include Mongoid::Document
  
  field :provider, :type => String
  field :uid, :type => String
  field :name, :type => String
  field :email, :type => String
  field :affiliation, :type => String
  field :admin, :type => Boolean, default: false
  field :approved, :type => Boolean, default: false
  
  attr_accessible :provider, :uid, :name, :email, :admin, :approved, :affiliation
  
  has_many :cruises
  
  scope :pending_approval, ->(){where(:approved => false)}
  
  
  def self.find_with_omniauth(auth)
    self.where(:provider => auth['provider'], :uid => auth['uid']).first
  end
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
        user.name = auth['info']['name'] || ""
        user.email = auth['info']['email'] || ""
      end
    end
  end  
  
  def admin?
    self.admin
  end
  
  def approved?
    self.approved
  end
end
