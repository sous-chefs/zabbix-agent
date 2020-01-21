# Author:: Nacer Laradji (<nacer.laradji@gmail.com>)
# Cookbook:: zabbix
# Recipe:: agent_source
#
# Copyright:: 2011, Efactures
#
# Apache 2.0
#
case node['platform_family']
when 'debian'
  apt_update

  # install some dependencies
  if (platform?('debian') && node['platform_version'].to_i >= 10) ||
     (platform?('ubuntu') && node['platform_version'].to_i >= 18)
    package %w(libcurl4 libcurl4-openssl-dev)
  else
    package %w(libcurl3 libcurl4-openssl-dev)
  end

when 'rhel', 'amazon', 'fedora'
  package %w(curl-devel openssl-devel redhat-lsb)
end

build_essential 'build-essentials'
# --prefix is controlled by install_dir
configure_options = node['zabbix']['agent']['configure_options'].dup
configure_options = (configure_options || []).delete_if do |option|
  option.match(/\s*--prefix(\s|=).+/)
end
node.override['zabbix']['agent']['configure_options'] = configure_options

remote_file "#{Chef::Config[:file_cache_path]}/#{node['zabbix']['agent']['tar_file']}" do
  source node['zabbix']['agent']['source_url']
  mode '0644'
  action :create
  notifies :run, 'bash[install_program]', :immediately
end

source_dir = "#{node['zabbix']['install_dir']}/zabbix-#{node['zabbix']['agent']['version']}"
bash 'install_program' do
  user 'root'
  cwd node['zabbix']['install_dir']
  code <<-EOH
    tar -zxf #{Chef::Config[:file_cache_path]}/#{node['zabbix']['agent']['tar_file']}
    (cd #{source_dir} && ./configure --enable-agent --prefix=#{node['zabbix']['install_dir']} #{node['zabbix']['agent']['configure_options'].join(' ')})
    (cd #{source_dir} && make install && touch already_built)
  EOH
  action :nothing
end
