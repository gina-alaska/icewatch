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

include_recipe 'icewatch::_application'

systemd_service 'puma' do
  description 'Icewatch Puma Application Server'
  after %w( network.target postgresql93.target redis.target)
  service do
    environment({ "ICEWATCH_APP" => "web" })
    exec_start "/usr/local/bin/hab start uafgina/icewatch --listen-peer #{node['ipaddress']}:9000 --listen-http #{node['ipaddress']}:8000"
    kill_signal 'SIGINT'
    kill_mode 'process'
    private_tmp true
  end
  only_if { ::File.open('/proc/1/comm').gets.chomp == 'systemd' } # systemd
end

service 'puma' do
  action [:enable, :start]
end
