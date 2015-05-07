yum_package 'ca-certificates' do
	action :nothing
end.run_action(:upgrade)

include_recipe 'yum-epel'

node[app_name]['databases'].each do |database|
  node.default['postgresql']['pg_hba'] += [{
  	:type => 'host',
  	:db => database['database'],
  	:user => database['username'],
  	:addr => 'all',
  	:method => 'trust'
  },{
    :type => 'host',
    :db => 'postgres',
    :user => database['username'],
    :addr => 'all',
    :method => 'trust'
  }]
end

include_recipe 'postgresql::server'
include_recipe 'database::postgresql'
include_recipe 'postgresql::ruby'
include_recipe 'chef-vault'

postgresql_connection_info = {
	host: '127.0.0.1',
	port: 5432,
	username: 'postgres',
	password: chef_vault_item(:secrets, app_name)['passwords']['postgres']
}

node[app_name]['databases'].each do |database|
  # create a postgresql database
  postgresql_database database['database'] do
    connection postgresql_connection_info
    action :create
  end

  # Create a postgresql user but grant no privileges
  postgresql_database_user database['username']] do
    connection postgresql_connection_info
    password   chef_vault_item(:secrets, app_name)['passwords'][database['username']]
    action     :create
  end

  # Grant all privileges on all tables in db
  postgresql_database_user database['username'] do
    connection    postgresql_connection_info
    database_name  database['database']
    privileges    [:all]
    action        :grant
  end
end