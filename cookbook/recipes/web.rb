tag('web')
node.set['icewatch']['precompile_assets'] = true
include_recipe 'chef-vault'
include_recipe 'runit'
include_recipe 'git'
include_recipe 'postgresql::client'
include_recipe "icewatch::_user"
include_recipe "icewatch::_ruby"
include_recipe "icewatch::_application"


runit_service "puma" do
  action [:enable, :start]
  log true
  default_logger true
  env({
    "RAILS_ENV" => 'production',
    "PORT" => node['icewatch']['puma_port'],
    "PUMA_PIDFILE" => "#{node['icewatch']['home']}/shared/pids/puma.pid"
  })

  subscribes :usr2, "deploy_revision[#{node['icewatch']['home']}]", :delayed
  subscribes :usr2, "template[#{node['icewatch']['home']}/shared/.env.production]", :delayed
end

include_recipe "icewatch::_nginx"
