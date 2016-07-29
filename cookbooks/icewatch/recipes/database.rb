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
include_recipe "chef-vault"

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

# include_recipe 'backup' 

# aws = icewatch_secrets['aws']
# backup_model :my_db do
#   description "Back up my database"

#   definition <<-DEF
#     split_into_chunks_of 4000

#     database Postgresql do |db|
#       db.name = '#{db['name']}'
#       db.username = '#{db['username']}'
#       db.password = '#{db['password']}'
#     end

#     compress_with Gzip

#     store_with S3 do |s3|
#       s3.access_key_id = '#{aws['access_key_id']}'
#       s3.secret_access_key = '#{aws['secret_access_key']}'
#       s3.bucket = 'gina-icewatch'
#     end
#   DEF

#   schedule({
#     :minute => 0,
#     :hour   => 0
#   })
# end