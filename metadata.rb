name              'zabbix-agent'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs/Configures Zabbix Agent'
source_url        'https://github.com/sous-chefs/zabbix-agent'
issues_url        'https://github.com/sous-chefs/zabbix-agent/issues'
version           '0.15.4'
chef_version      '>= 14'

%w(ubuntu redhat centos debian windows).each do |os|
  supports os
end

depends 'chocolatey'
