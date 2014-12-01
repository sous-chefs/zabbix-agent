name 'zabbix-agent'
maintainer 'Nacer Laradji'
maintainer_email 'nacer.laradji@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures Zabbix Agent/Server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.8.0'
supports 'ubuntu', '>= 10.04'
supports 'debian', '>= 6.0'
supports 'redhat', '>= 5.0'
supports 'centos', '>= 5.0'
supports 'oracle', '>= 5.0'
supports 'windows'

# change the needed recommends to depends below
recommends 'chocolatey' # For windows
depends 'apt'           # For Debian family OSs
depends 'yum'        # For Redhat family OSs
recommends 'ark'        # to install the prebuild packages
recommends 'java'       # if using the java gateway
