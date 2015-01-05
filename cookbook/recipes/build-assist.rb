include_recipe 'java::default'

node.set['chruby']['rubies'] = {
  'jruby' => true,
  '1.9.3-p392' => false
}
node.set['chruby']['default'] = 'jruby'

include_recipe 'chruby::system'

package 'zip'

gem_package 'bundler' do
  gem_binary ::File.join('/opt/rubies', node['chruby']['default'], 'bin/gem')
end

#Database config

rails_env = {"RAILS_ENV" => 'production'}
chruby_exec = "chruby-exec #{node['chruby']['default']} --"

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

execute 'warble-executeable-war' do
  command "#{chruby_exec} bundle exec warble executable war"
  cwd node['icewatch']['paths']['application']
  env rails_env
  creates 'assist.war'
end

execute 'create-distributable-zip' do
  command "zip assist.war"
  cwd node['iceatch']['paths']['application']
  creates 'assist.zip'
end
