#
# Cookbook Name:: cookbook
# Recipe:: worker
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

systemd_service 'sidekiq' do
  description 'Icewatch Sidekiq Worker'
  after %w( network.target postgresql93.target redis.target)
  service do
    environment({ "ICEWATCH_APP" => "worker" })
    exec_start "/usr/local/bin/hab start uafgina/icewatch --listen-peer #{node['ipaddress']}:9002 --listen-http #{node['ipaddress']}:8002"
    kill_signal 'SIGINT'
    kill_mode 'process'
    private_tmp true
  end
  only_if { ::File.open('/proc/1/comm').gets.chomp == 'systemd' } # systemd
end

service 'sidekiq' do
  action [:enable, :start]
end