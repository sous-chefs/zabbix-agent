require 'spec_helper'

# by default we will test with ubuntu 14.04
RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '14.04'
end

describe 'zabbix-agent with default settings + source install' do
  let(:chef_run) { ChefSpec::SoloRunner.converge('zabbix-agent::default') }
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['zabbix']['agent']['install_method'] = 'source'
    end.converge('zabbix-agent::default')
  end

  it 'includes zabbix-agent::install_source to compile and install the zabbix agent from source' do
    expect(chef_run).to include_recipe('zabbix-agent::install_source')
  end

  it 'uses the source lwrp to download and compile the source' do
    expect(chef_run).to source_agent_install('install_zabbix_agent')
  end
end
