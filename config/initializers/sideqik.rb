Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Kiqstand::Middleware
  end
  #config.redis = { :namespace => 'icewatch' }
  # if Rails.env == 'production'
  #   config.redis = { :url => 'redis://localhost:6379/12', :namespace => "icewatch_production" }
  # end
end