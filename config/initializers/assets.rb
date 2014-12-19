# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile.shift
Rails.application.config.assets.precompile.push ->(path) do
  File.extname(path).in? %w{.html .erb .haml .png .gif .jpg .jpeg .svg .eot .otf .svc .woff .ttf}
end
