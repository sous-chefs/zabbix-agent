# Author:: Nacer Laradji (<nacer.laradji@gmail.com>)
# Cookbook Name:: zabbix
# Recipe:: agent_prebuild
#
# Copyright 2011, Efactures
#
# Apache 2.0
#
remote_file "#{Chef::Config[:file_cache_path]}/#{node['zabbix']['agent']['prebuild_file']}" do
  source node['zabbix']['agent']['prebuild_url']
  mode '0644'
  action :create
  notifies :run, 'bash[install_program]', :immediately
end

bash 'install_program' do
  user 'root'
  cwd node['zabbix']['inst_dir']
  code <<-EOH
    tar -zxf #{Chef::Config[:file_cache_path]}/#{node['zabbix']['agent']['tar_file']}
  EOH
  action :nothing
end
