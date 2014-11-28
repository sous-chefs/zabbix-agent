# this can have issues if you don't have access
# to rubygems.org
chef_gem 'zabbixapi' do
  action :install
  version '~> 0.6.3'
end
