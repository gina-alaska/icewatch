node.override['nginx']['default_site_enabled'] = false
node.override['nginx']['repo_source'] = 'nginx'
include_recipe 'nginx'

ruby_block 'move_nginx_confs' do
  block do
    if File.exists? '/etc/nginx/conf.d'
      FileUtils::rm_rf '/etc/nginx/conf.d'
    end
  end
end

template "/etc/nginx/sites-available/icewatch_site" do
  source 'nginx_site.erb'
  variables({
    install_path: "#{node['icewatch']['home']}/current",
    name: 'icewatch',
    environment: node['icewatch']['environment'],
    port: node['icewatch']['puma_port']
  })
end

nginx_site "icewatch_site"
