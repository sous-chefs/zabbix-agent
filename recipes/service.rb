# Author:: Nacer Laradji (<nacer.laradji@gmail.com>)
# Cookbook Name:: zabbix
# Recipe:: service
#
# Copyright 2011, Efactures
#
# Apache 2.0
#
include_recipe 'zabbix-agent::configure'

case node['zabbix']['agent']['init_style']
when 'sysvinit'
  template '/etc/init.d/zabbix-agent' do
    source value_for_platform_family(['rhel'] => 'zabbix-agent.init-rh.erb', 'default' => 'zabbix-agent.init.erb')
    owner 'root'
    group 'root'
    mode '754'
    # use package init script if installed form package
    not_if { node['zabbix']['agent']['install_method'] == 'package' }
  end

  # Define zabbix-agent service
  service 'zabbix-agent' do
    pattern 'zabbix_agentd'
    supports :status => true, :start => true, :stop => true, :restart => true
    action [:enable, :start]
  end
when 'windows'
  service 'zabbix-agent' do
    service_name 'Zabbix Agent'
    provider Chef::Provider::Service::Windows
    supports :restart => true
    action :nothing
  end
else
  # Define just the zabbix-agent service
  service 'zabbix-agent' do
    pattern 'zabbix_agentd'
    supports :status => true, :start => true, :stop => true, :restart => true
    action [:enable, :start]
  end
end
