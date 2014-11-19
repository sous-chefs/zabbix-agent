# Author:: Nacer Laradji (<nacer.laradji@gmail.com>)
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright 2011, Efactures
#
# Apache 2.0
#

include_recipe "zabbix-agent::install_#{node['zabbix']['agent']['install_method']}"
include_recipe 'zabbix-agent::agent_common'

# Install configuration
template 'zabbix_agentd.conf' do
  path node['zabbix']['agent']['config_file']
  source 'zabbix_agentd.conf.erb'
  unless node['platform_family'] == 'windows'
    owner 'root'
    group 'root'
    mode '644'
  end
  notifies :restart, 'service[zabbix_agentd]'
end

# Install optional additional agent config file containing UserParameter(s)
template 'user_params.conf' do
  path node['zabbix']['agent']['userparams_config_file']
  source 'user_params.conf.erb'
  unless node['platform_family'] == 'windows'
    owner 'root'
    group 'root'
    mode '644'
  end
  notifies :restart, 'service[zabbix_agentd]'
  only_if { node['zabbix']['agent']['user_parameter'].length > 0 }
end

case node['zabbix']['agent']['init_style']
when 'sysvinit'
  template '/etc/init.d/zabbix_agentd' do
    source value_for_platform_family(['rhel'] => 'zabbix_agentd.init-rh.erb', 'default' => 'zabbix_agentd.init.erb')
    owner 'root'
    group 'root'
    mode '754'
    # use package init script if installed form package
    not_if { node['zabbix']['agent']['install_method'] == 'package' }
  end

  # Define zabbix_agentd service
  service 'zabbix_agentd' do
    service_name node['zabbix']['agent']['service_name']
    pattern 'zabbix_agentd'
    supports :status => true, :start => true, :stop => true, :restart => true
    action :nothing
  end
when 'windows'
  service 'zabbix_agentd' do
    service_name 'Zabbix Agent'
    provider Chef::Provider::Service::Windows
    supports :restart => true
    action :nothing
  end
end
