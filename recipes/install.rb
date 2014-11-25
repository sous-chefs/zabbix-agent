# Author:: Nacer Laradji (<nacer.laradji@gmail.com>)
# Cookbook Name:: zabbix
# Recipe:: agent_common
#
# Copyright 2011, Efactures
#
# Apache 2.0
#

# Manage user and group
if node['zabbix']['agent']['user']
  # Create zabbix group
  group node['zabbix']['agent']['group'] do
    gid node['zabbix']['agent']['gid'] if node['zabbix']['agent']['gid']
    system true
  end

  # Create zabbix User
  user node['zabbix']['agent']['user'] do
    home node['zabbix']['install_dir']
    shell node['zabbix']['agent']['shell']
    uid node['zabbix']['agent']['uid'] if node['zabbix']['agent']['uid']
    gid node['zabbix']['agent']['gid'] || node['zabbix']['agent']['group']
    system true
    supports :manage_home => true
  end
end

# Define root owned folders
root_dirs = [
  node['zabbix']['etc_dir'],
]

# Create root folders
case node['platform_family']
when 'windows'
  root_dirs.each do |dir|
    directory dir do
      owner 'Administrator'
      rights :read, 'Everyone', :applies_to_children => true
      recursive true
    end
  end
else
  root_dirs.each do |dir|
    directory dir do
      owner 'root'
      group 'root'
      mode '755'
      recursive true
    end
  end
end

# Define zabbix owned folders
zabbix_dirs = [
  node['zabbix']['log_dir'],
  node['zabbix']['run_dir']
]

# Create zabbix folders
zabbix_dirs.each do |dir|
  directory dir do
    owner node['zabbix']['login']
    group node['zabbix']['group']
    mode '755'
    recursive true
    # Only execute this if zabbix can't write to it. This handles cases of
    # dir being world writable (like /tmp)
    not_if { ::File.world_writable?(dir) }
  end
end

unless node['zabbix']['agent']['source_url']
  node.default['zabbix']['agent']['source_url'] = Chef::Zabbix.default_download_url(node['zabbix']['agent']['branch'], node['zabbix']['agent']['version'])
end

root_dirs = [
  node['zabbix']['agent']['include_dir']
]

# Create root folders
root_dirs.each do |dir|
  directory dir do
    unless node['platform'] == 'windows'
      owner 'root'
      group 'root'
      mode '755'
    end
    recursive true
    notifies :restart, 'service[zabbix_agentd]'
  end
end

include_recipe "zabbix-agent::install_#{node['zabbix']['agent']['install_method']}"
