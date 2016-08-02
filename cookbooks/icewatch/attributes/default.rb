#Database configuration
override['postgresql']['enable_pgdg_yum'] = true
override['postgresql']['version'] = "9.3"
override['postgresql']['dir'] = '/var/lib/pgsql/9.3/data'
override['postgresql']['config']['data_directory'] = '/var/lib/pgsql/9.3/data'
override['postgresql']['setup_script'] = '/usr/pgsql-9.3/bin/postgresql93-setup'
override['postgresql']['client']['packages'] = %w{postgresql93 postgresql93-devel}
override['postgresql']['server']['packages'] = %w{postgresql93-server}
override['postgresql']['server']['service_name'] = 'postgresql-9.3'
override['postgresql']['contrib']['packages'] = %w{postgresql93-contrib}
override['postgresql']['config']['listen_addresses'] = '0.0.0.0'

default['icewatch']['version'] = "3.0.1"
default['icewatch']['release'] = "20160802000731"
default['icewatch']['source'] = "https://s3-us-west-2.amazonaws.com/gina-icewatch/uafgina-icewatch-3.0.1-20160802000731-x86_64-linux.hart"
default['icewatch']['nginx'] = {
  'source' => 'https://s3-us-west-2.amazonaws.com/gina-icewatch/uafgina-icewatch-nginx-1.10.1-20160801185545-x86_64-linux.hart',
  'version' => '1.10.1',
  'release' => '20160801185545',
}
default['icewatch']['postgres_version'] = "core/postgresql/9.5.3"
default['icewatch']['redis_version'] = "core/redis/3.0.7"

default['icewatch']['cache'] = "/tmp"

default['icewatch']['database']['name'] = 'icewatch'
default['icewatch']['database']['username'] = 'icewatch'
default['icewatch']['database']['password'] = 'youshouldreallychangeme'
default['icewatch']['database']['pool'] = 5
default['icewatch']['database']['timeout'] = 5000
default['icewatch']['database']['host'] = 'localhost'
default['icewatch']['database']['port'] = 5432


default['icewatch']['storage']['actions'] = [:mount, :enable]