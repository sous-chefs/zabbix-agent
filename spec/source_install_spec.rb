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

  it "gets the file #{Chef::Config[:file_cache_path]}/zabbix-2.2.7.tar.gz" do
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/zabbix-2.2.7.tar.gz")
  end

  it 'notifies the install_program script to run immediately' do
    get_file = chef_run.remote_file("#{Chef::Config[:file_cache_path]}/zabbix-2.2.7.tar.gz")
    expect(get_file).to notify('bash[install_program]').to(:run).immediately
  end
end
