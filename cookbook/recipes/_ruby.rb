include_recipe "yum-gina"

node.default['rubies']['list']                 = ['ruby-2.2.2']
node.default['rubies']['bundler']['install']   = false
node.default['chruby_install']['default_ruby'] = 'ruby-2.2.2'

include_recipe 'rubies'

gem_package 'bundler' do
  gem_binary '/opt/rubies/ruby-2.2.2/bin/gem'
  version '>= 1.7.3'
end

%w(libxml2 libxml2-devel libxslt libxslt-devel postgresql-libs).each do |pkg|
  package pkg
end

%w(bundle bundler gem ruby rake erb irb rdoc ri testrb).each do |rb|
  link "/usr/bin/#{rb}" do
    to "/opt/rubies/#{node['icewatch']['ruby']['version']}/bin/#{rb}"
  end
end