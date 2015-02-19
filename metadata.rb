name 'zabbix-agent'
maintainer 'Bill Warner'
maintainer_email 'bill.warner@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures Zabbix Agent'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.11.0'
supports 'ubuntu', '>= 10.04'
supports 'debian', '>= 6.0'
supports 'redhat', '>= 5.0'
supports 'centos', '>= 5.0'
supports 'oracle', '>= 5.0'
supports 'windows'

# change the needed recommends to depends below
depends 'apt'             # For Debian family OSs
depends 'yum'             # For Redhat family OSs
depends 'build-essential' # for source build/install
recommends 'chocolatey'   # For Windows family OSs
recommends 'libzabbix'    # LWRPs to connect to zabbix server
