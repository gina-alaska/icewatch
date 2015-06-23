# package 'zip'

node.set['chruby']['rubies'] = {
  'jruby-1.7.20.1' => true,
  '1.9.3-p392' => false
}
node.set['chruby']['default'] = 'jruby-1.7.20.1'
node.set['icewatch']['paths']['application'] = '/Users/scott/workspace/icewatch'
# include_recipe 'java::default'
# include_recipe 'chruby::system'
#
# gem_package 'bundler' do
#   gem_binary ::File.join(ENV['RUBY_ROOT'],'..', node['chruby']['default'], 'bin/gem')
# end

#Database config

rails_env = {
  'RAILS_ENV' => 'production',
  'SECRET_KEY_BASE' => '31f071a9f7a37810dbfaa253b07c972be761a1fe90db090fb97382c12f84d8f0d0216ca9feddb430dc95c0e48f79b6a0136c6664e5a07d067dc7305b9b1e4fd3',
  'ICEWATCH_ASSIST' => 'true',
  'JRUBY_OPTS' => '--2.0'
}

chruby_exec = "chruby-exec #{node['chruby']['default']} --"

execute 'install-bundler' do
  command "#{chruby_exec} gem install bundler -v 1.9.9"
  env rails_env
end

execute 'bundle-install' do
  command "#{chruby_exec} bundle install"
  cwd node['icewatch']['paths']['application']
  env rails_env
end

execute 'create-database' do
  command "#{chruby_exec} bundle exec rake db:setup"
  cwd node['icewatch']['paths']['application']
  env rails_env
  creates 'db/production.sqlite3'
end

execute 'precompile-assets' do
  command "#{chruby_exec} bundle exec rake assets:precompile"
  cwd node['icewatch']['paths']['application']
  env rails_env
end

execute 'warble-executable-war' do
  command "#{chruby_exec} bundle exec warble executable war"
  cwd node['icewatch']['paths']['application']
  env rails_env
  creates 'assist.war'
end

release = node['icewatch']['assist-release'] || Time.now.strftime('%Y%m%d')
files = %w(ASSIST.war exports/launcher.* db/production.sqlite3)

execute 'create-distributable-zip' do
  command "zip -j ASSIST_#{release}.zip #{files.join(' ')} "
  cwd node['icewatch']['paths']['application']
  creates 'assist.zip'
end

# file 'ASSIST.war' do
#   action :delete
#   cwd node['icewatch']['paths']['application']
# end
#
# directory 'public/assets' do
#   action :delete
#   recursive true
#   cwd node['icewatch']['paths']['application']
# end
#
# file 'db/production.sqlite3' do
#   action :delete
#   cwd node['icewatch']['paths']['application']
# end
#
