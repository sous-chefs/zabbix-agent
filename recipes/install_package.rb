# Author:: Nacer Laradji (<nacer.laradji@gmail.com>)
# Cookbook:: zabbix
# Recipe:: agent_package
#
# Copyright:: 2011, Efactures
#
# Apache 2.0
#

case node['platform_family']
when 'windows'
  include_recipe 'chocolatey'
  chocolatey_package 'zabbix-agent'
when 'debian'
  apt_repository 'zabbix' do
    uri node['zabbix']['agent']['package']['repo_uri']
    distribution node['lsb']['codename']
    components ['main']
    key node['zabbix']['agent']['package']['repo_key']
  end

  package 'zabbix-agent' do
    options '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'
    action :upgrade
  end
when 'rhel', 'amazon', 'fedora'
  yum_repository 'zabbix' do
    repositoryid 'zabbix'
    description 'Zabbix Official Repository'
    baseurl node['zabbix']['agent']['package']['repo_uri']
    gpgkey node['zabbix']['agent']['package']['repo_key']
    sslverify false
    action :create
  end

  yum_repository 'zabbix-non-supported' do
    repositoryid 'zabbix-non-supported'
    description 'Zabbix Official Repository non-supported - $basearch'
    baseurl node['zabbix']['agent']['package']['repo_uri']
    gpgkey node['zabbix']['agent']['package']['repo_key']
    sslverify false
    action :create
  end

  package 'zabbix-agent' do
    action :upgrade
  end
end
