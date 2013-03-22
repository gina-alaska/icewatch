Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Kiqstand::Middleware
  end
  #config.redis = { :namespace => 'icewatch' }
end