name             'icewatch'
maintainer       'Scott Macfarlane'
maintainer_email 'sdmacfarlane@alaska.edu'
license          'APACHE2'
description      'Installs/Configures icewatch'
long_description 'Installs/Configures icewatch'
version          '3.1.3'

depends 'postgresql'
depends 'database'
depends 'chef-vault'
depends 'habitat-cookbook'
depends 'systemd'
depends 'nginx', '~> 2.7.0'