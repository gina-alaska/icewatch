#
# Cookbook Name:: icewatch
# Recipe:: nginx
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

# node.default['nginx']['repo_source'] = 'nginx'
# include_recipe 'nginx'
#
# template "#{node['nginx']['dir']}/sites-available/icewatch.conf" do
#   source 'nginx-icewatch.conf.erb'
# end
#
# nginx_site '000-default' do
#   enable false
# end
#
# nginx_site 'icewatch.conf' do
#   enable true
# end

gina_hab_package 'uafgina/icewatch-proxy' do
  source "https://s3-us-west-2.amazonaws.com/gina-packages/uafgina-icewatch-proxy-2.0.0-20170605203117-x86_64-linux.hart"
  checksum '394d063b6ce056ca2c3d6937d67d4d6ad750c3d43064c59209d00650f6079156'
end

hab_service 'uafgina/icewatch-proxy' do
  strategy 'at-once'
  bind 'app:icewatch.default'
  action [:load, :start]
end
