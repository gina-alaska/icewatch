include_recipe 'user'

account = data_bag_item('users', 'webdev')

group 'webdev' do
  gid account['gid'] || account['uid']
end

user_account 'webdev' do
  gid 'webdev'
  home node['icewatch']['home']
  comment 'Webdev'
  ssh_keys account['ssh_keys']
  ssh_keygen false
end

file ::File.join(node['icewatch']['home'], '.gemrc') do
  content 'gem: --no-ri --no-rdoc --bindir /usr/bin'
end