#
# Cookbook Name:: cookbook
# Recipe:: app
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

# This is for stand-alone installations of the application
#  All in one must use hab_director

include_recipe 'icewatch::_habitat'
include_recipe 'chef-vault'

gina_hab_package 'uafgina/icewatch' do
  source "https://s3-us-west-2.amazonaws.com/gina-packages/uafgina-icewatch-3.1.2-20170605200835-x86_64-linux.hart"
  checksum '58dd08d172388ddac4a5dc65be9433893d61437b9ee2b730b60cbc6cfec98552'
end

directory "/hab/svc/icewatch" do
  owner 'hab'
  group 'hab'
  action :create
end

icewatch_secrets = chef_vault_item('apps', 'icewatch')
database = node['icewatch']['database'].merge(icewatch_secrets['database'])

template '/hab/svc/icewatch/user.toml' do
  source 'icewatch-user.toml.erb'
  owner 'hab'
  group 'hab'
  mode '0600'
  variables({
    database: database,
    port: 9292,
    secret_key_base: icewatch_secrets['secret_key_base'],
    cache_path: node['icewatch']['cache'],
    google_secret: icewatch_secrets['google_secret'],
    google_key: icewatch_secrets['google_key']
  })
end

directory node['icewatch']['cache'] do
  action :create
end

hab_service 'uafgina/icewatch' do
  strategy 'at-once'
  action [:load, :start]
end

systemd_service 'sidekiq' do
  description 'Icewatch Sidekiq worker service'
  after %w( network.target )
  service do
    exec_start "/usr/bin/hab pkg exec uafgina/icewatch icewatch-worker"
    kill_signal 'SIGINT'
    kill_mode 'process'
    private_tmp true
  end
end

service 'sidekiq' do
  action  [:enable, :start]
end
# include_recipe 'icewatch::_application'
#
# systemd_service 'puma' do
#   description 'Icewatch Puma Application Server'
#   after %w( network.target postgresql93.target redis.target)
#   service do
#     environment({ "ICEWATCH_APP" => "web" })
#     exec_start "/usr/local/bin/hab start uafgina/icewatch --listen-peer #{node['ipaddress']}:9000 --listen-http #{node['ipaddress']}:8000"
#     kill_signal 'SIGINT'
#     kill_mode 'process'
#     private_tmp true
#   end
#   only_if { ::File.open('/proc/1/comm').gets.chomp == 'systemd' } # systemd
# end
#
# service 'puma' do
#   action [:enable, :start]
# end
