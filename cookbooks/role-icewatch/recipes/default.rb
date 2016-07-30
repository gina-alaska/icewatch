#
# Cookbook Name:: role-icewatch
# Recipe:: default
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

include_recipe 'gina-server'

node.default['icewatch']['cache'] = '/mnt/icewatch/cache'
include_recipe 'lvm'

lvm_volume_group 'vgCache' do
  physical_volumes ['/dev/vdb']

  logical_volume 'cache' do
    size        '100%VG'
    filesystem  'ext4'
    mount_point location: '/mnt/icewatch', options: 'noatime,nodiratime'
  end

  only_if { ::File.blockdev?('/dev/vdb') }
end

# Get hab user prepped
include_recipe 'icewatch::_habitat'

directory node['icewatch']['cache'] do
  action :create
  recursive true
  owner 'hab'
  group 'hab'
end

node.override['icewatch']['version'] = '20160730011508'
node.override['icewatch']['source'] = 'https://s3-us-west-2.amazonaws.com/gina-icewatch/uafgina-icewatch-3.0.0-20160730011508-x86_64-linux.hart'
node.override['icewatch']['nginx'] = {
  'source' => "https://s3-us-west-2.amazonaws.com/gina-icewatch/uafgina-icewatch-nginx-1.10.1-20160730011208-x86_64-linux.hart",
  'release' => "20160730011208"
}

 
include_recipe 'icewatch::database'
include_recipe 'icewatch::redis'
include_recipe 'icewatch::app'
include_recipe 'icewatch::nginx'
include_recipe 'icewatch::worker'

directory node['icewatch']['cache'] do 
  action :create
  owner 'hab'
  group 'hab'
  recursive true
end

node.default['firewall']['redhat7_iptables'] = true

# Explicitly disable firewalld
service 'firewalld' do
  action [:stop, :disable]
end

# include_recipe 'firewall'

# firewall_rule 'allow ssh gina' do
#   port 22
#   source '137.229.19.0/24'
#   command :allow
# end

# firewall_rule 'allow ssh gina private' do
#   port 22
#   source '10.19.16.0/24'
#   command :allow
# end

# firewall_rule 'allow http' do
#   port 80
#   command :allow
# end

# firewall_rule 'allow localhost' do
#   source '127.0.0.1/32'
#   command :allow
# end

# firewall_rule 'allow myself' do
#   source "#{node['ipaddress']}/32"
#   command :allow
# end