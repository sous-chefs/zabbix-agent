require 'spec_helper'

# by default we will test with ubuntu 14.04
RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '14.04'
end

describe 'zabbix-agent with install_method=source' do
  let(:chef_source) do
    ChefSpec::ServerRunner.new do |node|
      node.set['zabbix']['agent']['install_method'] = 'source'
    end.converge('zabbix-agent::install_source')
  end
  # changed node['zabbix']['agent']['install_method'] = source
  it 'includes zabbix-agent::install_source to install zabbbix from source' do
    expect(chef_source).to include_recipe('zabbix-agent::install_source')
  end

  it 'gets the zabbix archive zabbix-2.2.7.tar.gz' do
    expect(chef_source).to create_remote_file("#{Chef::Config[:file_cache_path]}/zabbix-2.2.7.tar.gz")
  end

  it 'the zabbix archive zabbix-2.2.7.tar.gz notifies the bash install_program' do
    get_file = chef_source.remote_file("#{Chef::Config[:file_cache_path]}/zabbix-2.2.7.tar.gz")
    expect(get_file).to notify('bash[install_program]').to(:run).immediately
  end
end
