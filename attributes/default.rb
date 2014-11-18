#
# Cookbook Name:: zabbix
# Attributes:: default

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

default['zabbix']['agent']['install']           = true
default['zabbix']['agent']['service_state']     = [:start, :enable]
default['zabbix']['agent']['service_name']      = 'zabbix_agentd'

default['zabbix']['agent']['branch']            = 'ZABBIX%20Latest%20Stable'
default['zabbix']['agent']['version']           = '2.2.0'
default['zabbix']['agent']['source_url']        = nil
default['zabbix']['agent']['servers']           = []
default['zabbix']['agent']['servers_active']    = []
default['zabbix']['agent']['hostname']          = node['fqdn']
default['zabbix']['agent']['configure_options'] = ['--with-libcurl']
default['zabbix']['agent']['include_dir']       = ::File.join(node['zabbix']['etc_dir'], 'agent_include')
default['zabbix']['agent']['enable_remote_commands'] = true
default['zabbix']['agent']['listen_port']       = '10050'
default['zabbix']['agent']['timeout']           = '3'

default['zabbix']['agent']['config_file']               = ::File.join(node['zabbix']['etc_dir'], 'zabbix_agentd.conf')
default['zabbix']['agent']['userparams_config_file']    = ::File.join(node['zabbix']['agent']['include_dir'], 'user_params.conf')

default['zabbix']['agent']['groups']            = ['chef-agent']

case node['platform_family']
when 'rhel', 'debian'
  default['zabbix']['agent']['init_style']      = 'sysvinit'
  default['zabbix']['agent']['install_method']  = 'prebuild'
  default['zabbix']['agent']['pid_file']        = ::File.join(node['zabbix']['run_dir'], 'zabbix_agentd.pid')

  default['zabbix']['agent']['user']            = 'zabbix'
  default['zabbix']['agent']['group']           = node['zabbix']['agent']['user']

  default['zabbix']['agent']['shell']           = node['zabbix']['shell']
when 'windows'
  default['zabbix']['agent']['init_style']      = 'windows'
  default['zabbix']['agent']['install_method']  = 'chocolatey'
end

default['zabbix']['agent']['log_file']           = nil # default (Syslog / windows event).
# default['zabbix']['agent']['log_file']           = ::File.join(node['zabbix']['log_dir'], "zabbix_agentd.log"
default['zabbix']['agent']['start_agents']       = nil # default (3)
default['zabbix']['agent']['debug_level']        = nil # default (3)
default['zabbix']['agent']['templates']          = []
default['zabbix']['agent']['interfaces']         = ['zabbix_agent']
default['zabbix']['agent']['jmx_port']           = '10052'
default['zabbix']['agent']['zabbix_agent_port']  = '10050'
default['zabbix']['agent']['snmp_port']          = '161'

default['zabbix']['agent']['user_parameter'] = []

default['zabbix']['install_dir']  = '/opt/zabbix'
default['zabbix']['web_dir']      = '/opt/zabbix/web'
default['zabbix']['external_dir'] = '/opt/zabbix/externalscripts'
default['zabbix']['alert_dir']    = '/opt/zabbix/AlertScriptsPath'
default['zabbix']['lock_dir']     = '/var/lock/subsys'
default['zabbix']['src_dir']      = '/opt'
default['zabbix']['log_dir']      = '/var/log/zabbix'
default['zabbix']['run_dir']      = '/var/run/zabbix'

default['zabbix']['login']  = 'zabbix'
default['zabbix']['group']  = 'zabbix'
default['zabbix']['uid']    = nil
default['zabbix']['gid']    = nil
default['zabbix']['home']   = '/opt/zabbix'
default['zabbix']['shell']  = '/bin/bash'

# download prebuild binaries
default['zabbix']['agent']['prebuild']['arch']  = node['kernel']['machine'] == 'x86_64' ? 'amd64' : 'i386'
default['zabbix']['agent']['prebuild']['url']      = "http://www.zabbix.com/downloads/#{node['zabbix']['agent']['version']}/zabbix_agents_#{node['zabbix']['agent']['version']}.linux2_6.#{node['zabbix']['agent']['prebuild']['arch']}.tar.gz"
default['zabbix']['agent']['checksum'] = 'ec3d19dcdf484f60bc4583a84a39a3bd59c34ba1e7f8abf9438606eb14b90211'

# setup packaged downloads
case node['platform']
when 'ubuntu', 'debian'
  default['zabbix']['agent']['package']['repo_uri'] = "http://repo.zabbix.com/zabbix/2.4/#{node['platform']}/"
  default['zabbix']['agent']['package']['repo_key'] = 'http://repo.zabbix.com/zabbix-official-repo.key'
when 'redhat', 'centos'
  default['zabbix']['agent']['package']['repo_uri'] = "http://repo.zabbix.com/zabbix/2.4/rhel/#{node['platform_version'].to_i}/$basesearch"
  default['zabbix']['agent']['package']['repo_key'] = 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX'
end

