#
# Cookbook Name:: cookbook
# Recipe:: hab_director
#
# The MIT License (MIT)
#
# Copyright (c) 2016 UAF GINA
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

icewatch_secrets = chef_vault_item("apps", "icewatch")
db_secrets = icewatch_secrets['database']
db = node['icewatch']['database'].merge(db_secrets)

node.set['postgresql']['password']['postgres'] = icewatch_secrets['passwords']['postgres']

include_recipe "postgresql::server"
include_recipe "database::postgresql"
include_recipe "chef-vault"

postgresql_connection_info = {
  host: "127.0.0.1",
  port: "5432",
	username: 'postgres',
  password: icewatch_secrets['passwords']['postgres']
}

postgresql_database db['name'] do 
  connection postgresql_connection_info
  action :create
end

postgresql_database_user db['username'] do
  connection postgresql_connection_info
  password   db['password']
  action     :create
  not_if db['password'].nil?
end


postgresql_database_user db['username'] do
  connection    postgresql_connection_info
  database_name db['name']
  privileges    [:all]
  action        :grant
end


# postgresql = node['icewatch']['postgres_version']

# execute 'hab-install-postgresql' do 
#   command "hab pkg install #{postgresql}"
# end

# directory '/hab/svc/postgresql' do
#   owner 'hab'
#   group 'hab'
#   recursive true
# end

# include_recipe 'chef-vault'
# icewatch_vault = chef_vault_item('apps', 'icewatch')
# db_password = icewatch_vault['initdb_superuser_password']

# template '/hab/svc/postgresql/user.toml' do
#   source "postgres-user.toml.erb"
#   owner 'hab'
#   group 'hab'
#   mode '0600'
#   variables({
#     initdb_superuser_password: db_password
#   })
# end

# systemd_service 'postgresql' do
#   description 'Postgresql Database Server'
#   after %w( network.target )
#   service do
#     environment 'LANG' => 'C'
#     exec_start "/usr/local/bin/hab start #{postgresql}"
#     kill_signal 'SIGWINCH'
#     kill_mode 'mixed'
#     private_tmp true
#   end
#   only_if { ::File.open('/proc/1/comm').gets.chomp == 'systemd' } # systemd
# end

# service 'postgresql' do
#   action [:enable, :start]
# end


# TODO: Set up backups
