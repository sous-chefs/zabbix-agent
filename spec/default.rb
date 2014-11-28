require 'chefspec'

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
end
