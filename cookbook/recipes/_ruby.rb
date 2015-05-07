include_recipe "yum-gina"

package node['icewatch']['ruby']['package']
include_recipe 'chruby'


%w(libxml2 libxml2-devel libxslt libxslt-devel postgresql-libs).each do |pkg|
  package pkg
end

%w(bundle bundler ruby).each do |rb|
  link "/usr/bin/#{rb}" do
    to "/opt/rubies/#{node['icewatch']['ruby']['version']}/bin/#{rb}"
  end
end 