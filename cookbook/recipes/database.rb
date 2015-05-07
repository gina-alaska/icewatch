include_recipe "postgresql::ruby"
include_recipe 'chef-vault'

yum_package 'ca-certificates' do
	action :nothing
end.run_action(:upgrade)

include_recipe 'yum-epel'

app = chef_vault_item(:apps, node['icewatch']['data_bag'])

node.set['postgresql']['password']['postgres'] = app['passwords']['postgres']

node.default['postgresql']['pg_hba'] += [{
	:type => 'host',
	:db => app['env']['rails_database'],
	:user => app['env']['rails_database_username'],
	:addr => 'all',
	:method => 'trust'
},{
  :type => 'host',
  :db => 'postgres',
  :user => app['env']['rails_database_username'],
  :addr => 'all',
  :method => 'trust'
}]


include_recipe 'postgresql::server'
include_recipe 'database::postgresql'

postgresql_connection_info = {
	host: '127.0.0.1',
	port: 5432,
	username: 'postgres',
	password: app['passwords']['postgres']
}

# create a postgresql database
postgresql_database app['env']['rails_database'] do
  connection postgresql_connection_info
  action :create
end

# Create a postgresql user but grant no privileges
postgresql_database_user app['env']['rails_database_username'] do
  connection postgresql_connection_info
  password   app['passwords']['icewatch']  #node[app_name]['database']['password']
  action     :create
end

# Grant all privileges on all tables in foo db
postgresql_database_user 'icewatch' do
  connection    postgresql_connection_info
  database_name  app['env']['rails_database']
  privileges    [:all]
  action        :grant
end

ruby_block 'smash-postgres-auth-attributes' do
  block do
    node.rm('postgresql', 'password', 'postgres')
  end
  # subscribes :create, 'bash[assign-postgres-password]', :immediately
end