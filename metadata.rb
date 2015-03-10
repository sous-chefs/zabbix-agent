name 'zabbix-agent'
maintainer 'Bill Warner'
maintainer_email 'bill.warner@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures Zabbix Agent'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.13.0'

supports 'ubuntu', '>= 10.04'
supports 'ubuntu', '>= 12.04'
supports 'ubuntu', '>= 14.04'
supports 'centos', '>= 6.6'
supports 'centos', '>= 7.0'
supports 'debian', '>= 6.0.10'
supports 'debian', '>= 7.0'

# change the needed recommends to depends below
depends 'apt'             # For Debian family OSs
depends 'yum'             # For Redhat family OSs
depends 'build-essential' # for source build/install
recommends 'chocolatey'   # For Windows family OSs
recommends 'libzabbix'    # LWRPs to connect to zabbix server
