#
# Cookbook Name:: zabbix
# Attributes:: default

# Directories
case node['platform_family']
when 'windows'
  if ENV['ProgramFiles'] == ENV['ProgramFiles(x86)']
    # if user has never logged into an interactive session then ENV['homedrive'] will be nil
    default['zabbix']['etc_dir']    = ::File.join((ENV['homedrive'] || 'C:'), 'Program Files', 'Zabbix Agent')
  else
    default['zabbix']['etc_dir']    = ::File.join(ENV['ProgramFiles'], 'Zabbix Agent')
  end
else
  default['zabbix']['etc_dir']      = '/etc/zabbix'
end
default['zabbix']['agent']['include_dir']            = ::File.join(node['zabbix']['etc_dir'], 'zabbix_agentd.d')
default['zabbix']['agent']['config_file']            = ::File.join(node['zabbix']['etc_dir'], 'zabbix_agentd.conf')
default['zabbix']['agent']['userparams_config_file'] = ::File.join(node['zabbix']['agent']['include_dir'], 'user_params.conf')

default['zabbix']['agent']['version']           = '2.2.7'
default['zabbix']['agent']['servers']           = ['zabbix']
default['zabbix']['agent']['servers_active']    = ['zabbix']

# primary config options
default['zabbix']['agent']['hostname']          = node['fqdn']
default['zabbix']['agent']['user']              = 'zabbix'
default['zabbix']['agent']['group']             = node['zabbix']['agent']['user']
default['zabbix']['agent']['timeout']           = '3'
default['zabbix']['agent']['listen_port']       = '10050'
default['zabbix']['agent']['log_file']          = nil # default (Syslog / windows event).
default['zabbix']['agent']['start_agents']      = nil # default (3)
default['zabbix']['agent']['debug_level']       = nil # default (3)
default['zabbix']['agent']['templates']         = []
default['zabbix']['agent']['interfaces']        = ['zabbix_agent']
default['zabbix']['agent']['jmx_port']          = '10052'
default['zabbix']['agent']['zabbix_agent_port'] = '10050'
default['zabbix']['agent']['enable_remote_commands'] = true
default['zabbix']['agent']['snmp_port']         = '161'
default['zabbix']['agent']['install_method']    = 'package'
default['zabbix']['agent']['user_parameter']    = []
default['zabbix']['agent']['scripts']           = '/etc/zabbix/scripts'
default['zabbix']['agent']['shell']  = '/bin/bash'

default['zabbix']['install_dir']  = '/opt/zabbix'

default['zabbix']['lock_dir']     = '/var/lock/subsys'
default['zabbix']['log_dir']      = '/var/log/zabbix'
default['zabbix']['run_dir']      = '/var/run/zabbix'

# source install
default['zabbix']['agent']['configure_options'] = ['--with-libcurl']

download_url = 'http://downloads.sourceforge.net/project/zabbix/'
branch       = 'ZABBIX%20Latest%20Stable'
version      = node['zabbix']['agent']['version']
tar          = "zabbix-#{version}.tar.gz"
default['zabbix']['agent']['source_url'] = "#{download_url}/#{branch}/#{version}/#{tar}"
default['zabbix']['agent']['tar_file'] = tar

# package install
case node['platform']
when 'ubuntu', 'debian'
  default['zabbix']['agent']['package']['repo_uri'] = "http://repo.zabbix.com/zabbix/2.4/#{node['platform']}/"
  default['zabbix']['agent']['package']['repo_key'] = 'http://repo.zabbix.com/zabbix-official-repo.key'
when 'redhat', 'centos', 'scientific', 'oracle', 'amazon'
  default['zabbix']['agent']['package']['repo_uri'] = 'http://repo.zabbix.com/zabbix/2.4/rhel/$releasever/$basearch/'
  default['zabbix']['agent']['package']['repo_key'] = 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX'
end

# prebuild install
prebuild_url = 'http://www.zabbix.com/downloads/'
arch = node['kernel']['machine'] == 'x86_64' ? 'amd64' : 'i386'
default['zabbix']['agent']['prebuild_file'] = "zabbix_agents_#{version}.linux2_6.#{arch}.tar.gz"

default['zabbix']['agent']['prebuild_url']  = "#{prebuild_url}#{version}/zabbix_agents_#{version}.linux2_6.#{arch}.tar.gz"
default['zabbix']['agent']['checksum']         = 'bf2ebb48fbbca66418350f399819966e'

# auto-regestration
default['zabbix']['agent']['groups']            = ['chef-agent']

case node['platform_family']
when 'rhel', 'debian'
  default['zabbix']['agent']['init_style']      = 'sysvinit'
  default['zabbix']['agent']['pid_file']        = ::File.join(node['zabbix']['run_dir'], 'zabbix_agentd.pid')
when 'windows'
  default['zabbix']['agent']['init_style']      = 'windows'
  default['zabbix']['agent']['install_method']  = 'chocolatey'
end
