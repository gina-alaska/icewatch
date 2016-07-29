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

nginx = node['icewatch']['nginx']
nginx_package = "#{Chef::Config[:file_cache_path]}/uafgina-icewatch-nginx-#{nginx['version']}.hart"

remote_file nginx_package do 
  source nginx['source']
  notifies :run, 'execute[hab-install-nginx]', :immediately
end

execute 'hab-install-nginx' do 
  action :nothing
  command "hab pkg install #{nginx_package}"
end

directory '/hab/svc/icewatch-nginx' do
  recursive true
end

template '/hab/svc/icewatch-nginx/user.toml' do
  source 'nginx-user.toml.erb'
  owner 'hab'
  group 'hab'
  mode '0600'
  variables({
    ip: node['ipaddress'],
    port: 9292
  })
end