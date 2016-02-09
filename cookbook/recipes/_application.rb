include_recipe 'nodejs'

nodejs_npm "bower"

directory node['icewatch']['home'] do
  user 'webdev'
  group 'webdev'
  mode 0755
  recursive true
end

directory "#{node['icewatch']['home']}/shared" do
  user 'webdev'
  group 'webdev'
  mode 755
  recursive true
end

directory "#{node['icewatch']['home']}/shared/bundle" do
  user 'webdev'
  group 'webdev'
  mode 0755
  recursive true
end

app = chef_vault_item(:apps, node['icewatch']['data_bag'])
database_host = search(:node, 'roles:icewatch-database', filter_result: {'ip' => ['ipaddress']})
database_host  = [{'ip' => '127.0.0.1'}] if database_host.empty?

template "#{node['icewatch']['home']}/shared/.env.production" do
  source "env.erb"
  user 'webdev'
  group 'webdev'

  variables({env: app['env'].merge({
     rails_database_host: database_host.first['ip'],
     rails_database_password: app['passwords']['icewatch'],
   })
  })
end

deploy_revision node['icewatch']['home'] do
  repo app['repository']
  revision app['revision']
  user 'webdev'
  group 'webdev'
  migrate false
  migration_command 'bundle exec rake db:migrate'
  environment 'RAILS_ENV' => 'production'
  action node['icewatch']['deploy_action'] || 'deploy'

  symlink_before_migrate({
    '.env.production' => '.env',
    'tmp' => 'tmp',
  })

  before_migrate do
    %w(pids log system public tmp).each do |dir|
      directory "#{node['icewatch']['home']}/shared/#{dir}" do
        mode 0755
        recursive true
      end
    end

    execute 'bundle install' do
      cwd release_path
      user 'webdev'
      group 'webdev'
      command "bundle install --without test development --path=#{node['icewatch']['home']}/shared/bundle"
      environment({"BUNDLE_BUILD__PG" => "--with-pg_config=/usr/pgsql-#{node['postgresql']['version']}/bin/pg_config"})
    end
  end

  before_restart do
    execute 'assets:precompile' do
      user 'webdev'
      group 'webdev'
      environment 'RAILS_ENV' => 'production'
      cwd release_path
      command 'bundle exec rake assets:precompile'
      only_if { node['icewatch']['precompile_assets'] }
    end
  end

  after_restart do
    execute 'chown-release_path-assets' do
      command "chown -R webdev:webdev #{release_path}/public/assets"
      user 'root'
      action :run
      only_if { ::File.exists? "#{release_path}/public/assets"}
    end
  end
end