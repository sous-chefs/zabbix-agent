require 'spec_helper'

# by default we will test with ubuntu 14.04
RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '14.04'
end

describe 'zabbix-agent with install_method=prebuild' do
  let(:chef_prebuild) do
    ChefSpec::ServerRunner.new do |node|
      node.set['zabbix']['agent']['install_method'] = 'prebuild'
    end.converge('zabbix-agent::default')
  end
  # changed node['zabbix']['agent']['install_method'] = prebuild
  it 'includes zabbix-agent::install_prebuild to install zabbbix from prebuild tar files' do
    expect(chef_prebuild).to include_recipe('zabbix-agent::install_prebuild')
  end

  it 'gets the zabbix archive zabbix-2.2.7.tar.gz' do
    expect(chef_prebuild).to create_remote_file("#{Chef::Config[:file_cache_path]}/zabbix_agents_2.2.7.linux2_6.amd64.tar.gz")
  end

  it 'notifies the bash install_program when the archive is downloaded' do
    get_file = chef_prebuild.remote_file("#{Chef::Config[:file_cache_path]}/zabbix_agents_2.2.7.linux2_6.amd64.tar.gz")
    expect(get_file).to notify('bash[install_program]').to(:run).immediately
  end
end
