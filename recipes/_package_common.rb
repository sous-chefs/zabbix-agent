# Author:: Nacer Laradji (<nacer.laradji@gmail.com>)
# Cookbook Name:: zabbix
# Recipe:: _package_common
#
# Copyright 2011, Efactures
#
# Apache 2.0
#
case node['platform']
when 'ubuntu', 'debian'
  include_recipe 'apt'
  apt_repository 'zabbix' do
    uri node['zabbix']['agent']['package']['repo_uri']
    distribution node['lsb']['codename']
    components ['main']
    key node['zabbix']['agent']['package']['repo_key']
  end
when 'redhat', 'centos', 'scientific', 'oracle', 'amazon'
  include_recipe 'yum' # ~FC007
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
when 'windows'
  include_recipe 'chocolatey' # ~FC007
  chocolatey 'zabbix-agent'
end
