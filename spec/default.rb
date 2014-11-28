require 'chefspec'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '14.04'
end

describe 'zabbix-agent' do
  # default run
  let(:chef_run) { ChefSpec::SoloRunner.converge('zabbix-agent') }

  it 'includes zabbix-agent::service' do
    expect(chef_run).to include_recipe('zabbix-agent::service')
  end

  it 'includes zabbix-agent::configure' do
    expect(chef_run).to include_recipe('zabbix-agent::configure')
  end

  it 'includes zabbix-agent::install' do
    expect(chef_run).to include_recipe('zabbix-agent::install')
  end

  it 'includes zabbix-agent::install_package' do
    expect(chef_run).to include_recipe('zabbix-agent::install_package')
  end

  it 'includes zabbix-agent::_package_common' do
    expect(chef_run).to include_recipe('zabbix-agent::_package_common')
  end

  it 'installs the package zabbix-agent' do
    expect(chef_run).to install_package('zabbix-agent')
  end
end
