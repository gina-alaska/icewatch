require 'omniauth-openid'
require 'openid/store/memcache'
require 'openid/fetchers'
if ::File.exists? "/etc/ssl/certs/ca-bundle.crt"
  OpenID.fetcher.ca_file = "/etc/ssl/certs/ca-bundle.crt"  #This is where it lives on centos
end

Rails.application.config.middleware.use OmniAuth::Builder do
  memcached_client = Dalli::Client.new("flash.x.gina.alaska.edu",
                                        username: ENV['MEMCACHE_USERNAME'],
                                        password: ENV['MEMCACHE_PASSWORD'])
  provider :open_id, name: 'google', 
           identifier: 'https://www.google.com/accounts/o8/id',
           #identifier: 'https://id.gina.alaska.edu',
           store: OpenID::Store::Memcache.new(memcached_client)
end