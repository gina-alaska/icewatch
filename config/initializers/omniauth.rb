require 'omniauth-openid'
require 'openid/store/filesystem'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :open_id, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id', :store => OpenID::Store::Filesystem.new('/tmp')
end