#Database configuration
override['postgresql']['enable_pgdg_yum'] = true
override['postgresql']['version'] = "9.3"
override['postgresql']['dir'] = '/var/lib/pgsql/9.3/data'
override['postgresql']['config']['data_directory'] = '/var/lib/pgsql/9.3/data'
override['postgresql']['client']['packages'] = %w{postgresql93 postgresql93-devel}
override['postgresql']['server']['packages'] = %w{postgresql93-server}
override['postgresql']['server']['service_name'] = 'postgresql-9.3'
override['postgresql']['contrib']['packages'] = %w{postgresql93-contrib}
override['postgresql']['config']['listen_addresses'] = '0.0.0.0'



# default['icewatch']['database']['name'] = 'icewatch'
# default['icewatch']['database']['database'] = 'icewatch'
# default['icewatch']['database']['hostname'] = "localhost"
# default['icewatch']['database']['username'] = 'icewatch'
# default['icewatch']['database']['password'] = nil
# default['icewatch']['database']['adapter'] = 'postgresql'
# default['icewatch']['database']['client_encoding'] = 'UTF8'
# default['icewatch']['database']['pool'] = 5
# default['icewatch']['database']['schema_search_path'] = 'icewatch,public'

default['icewatch']['environment'] = "development"
default['icewatch']['data_bag'] = 'icewatch-test'

#Path configuration
default['icewatch']['home'] = '/www/icewatch'


default['icewatch']['puma_port'] = '5000'

default['icewatch']['ruby'] = {
  'version' => 'ruby-2.2.2',
  'package' => 'gina-ruby-21'
}

default['icewatch']['storage']['actions'] = [:mount, :enable]