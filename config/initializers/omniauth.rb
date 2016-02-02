  require 'openid/store/filesystem'

  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :developer unless Rails.env.production?
    # provider :google_oauth2, ENV["GOOGLE_KEY"], ENV["GOOGLE_SECRET"], {
    #   name: "google",
    #   scope: "userinfo.email, userinfo.profile",
    #   image_aspect_ratio: "square",
    #   image_size: 50# ,
    #   prompt: 'consent'
    # }
    # provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
    provider :openid, :store => OpenID::Store::Filesystem.new('./tmp'), :name => 'gina', :identifier => 'https://id.gina.alaska.edu'
    provider :google_oauth2, Rails.application.secrets.google_key, Rails.application.secrets.google_secret, {
      name: 'google',
      scope: 'userinfo.profile,userinfo.email',
      # leave this out for now for dev purposes
      # hd: "alaska.edu",
      include_granted_scopes: true,
      # scope: "userinfo.profile",
      #image_aspect_ratio: "square",
      #image_size: 50,
      # prompt: 'select_account'
    }
  end
