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

include_recipe "icewatch::_habitat"

directory "/hab/svc/hab-director" do
  action :create
  mode "0700"
  owner 'hab'
  group 'hab'
  recursive true
end

systemd_service 'hab-director' do
  description 'Icewatch Habitat Director'
  after %w( network.target postgresql93.target )
  service do
    exec_start "/usr/local/bin/hab start core/hab-director"
    kill_signal 'SIGWINCH'
    kill_mode 'mixed'
    private_tmp true
  end
  only_if { ::File.open('/proc/1/comm').gets.chomp == 'systemd' } # systemd
end

service 'hab-director' do
  action [:enable, :start]
end

include_recipe "icewatch::_redis"
include_recipe "icewatch::_application"
include_recipe "icewatch::_nginx"

# origin.name.group.organization[.env]
services = {
  "core.redis.icewatch.prod" => {
    "start" => "--permanent-peer"
  },
  "uafgina.icewatch.icewatch.prod" => {
    "start" => "--permanent-peer"
  },
  # "uafgina.icewatch.icewatch.prod.env" => {
  #   "ICEWATCH_SERVICE" => "web"
  # },
  "uafgina.icewatch-nginx.icewatch.prod" => {
    "start" => "--permanent-peer --bind app:icewatch.prod"
  }
}

template '/hab/svc/hab-director/chef.toml' do
  source 'hab-director-chef.toml.erb'  
  owner 'hab'
  group 'hab'
  variables({
    services: services
  })
  notifies :nothing, "execute[apply-hab-director-toml]", :immediately
end

execute 'apply-hab-director-toml' do
  action :nothing
  command "/usr/local/bin/hab apply hab-director.default --peer #{node['ipaddress']} #{Time.now.to_i} /hab/svc/hab-director/chef.toml"
end