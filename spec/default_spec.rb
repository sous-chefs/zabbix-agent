require 'spec_helper'

# by default we will test with ubuntu 14.04
RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '14.04'
end

describe 'zabbix-agent with default settings' do
  let(:chef_run) { ChefSpec::ServerRunner.converge('zabbix-agent::default') }

  it 'includes zabbix-agent::service to insure the zabbix agent will run' do
    expect(chef_run).to include_recipe('zabbix-agent::service')
  end

  it 'includes zabbix-agent::configure to configure the zabbix agent' do
    expect(chef_run).to include_recipe('zabbix-agent::configure')
  end

  it 'includes zabbix-agent::install to install the zabbix agent' do
    expect(chef_run).to include_recipe('zabbix-agent::install')
  end

  it 'adds the group "zabbix"' do
    expect(chef_run).to create_group('zabbix')
  end

  it 'adds the user "zabbix" to run the zabbix_agentd as' do
    expect(chef_run).to create_user('zabbix')
  end

  it 'creates the directory /etc/zabbix owned by root.root and mode 755 to store configurations, scripts and UserParamiters' do
    expect(chef_run).to create_directory('/etc/zabbix').with(
      user:   'root',
      group:  'root',
      mode:   '755'
    )
  end

  it 'creates the directory /etc/zabbix/agent_include owned by root.root and mode 755 to store configurations, scripts and UserParamiters' do
    expect(chef_run).to create_directory('/etc/zabbix/agent_include').with(
      user:   'root',
      group:  'root',
      mode:   '755'
    )
  end

  it 'creates the directory /var/log/zabbix owned by zabbix.zabbix and mode 755 to store zabbix_agentd logs' do
    expect(chef_run).to create_directory('/var/log/zabbix').with(
      user:   'zabbix',
      group:  'zabbix',
      mode:   '755'
    )
  end

  it 'creates the directory /var/run/zabbix owned by zabbix.zabbix and mode 755 to store the PID file' do
    expect(chef_run).to create_directory('/var/run/zabbix').with(
      user:   'zabbix',
      group:  'zabbix',
      mode:   '755'
    )
  end

  # default node['zabbix']['agent']['install_method'] = package
  it 'includes zabbix-agent::install_package to install the zabbix agent from the package' do
    expect(chef_run).to include_recipe('zabbix-agent::install_package')
    expect(chef_run).to include_recipe('apt')
    expect(chef_run).to install_package('zabbix-agent')
  end

  # changed node['zabbix']['agent']['install_method'] = source
  it 'includes zabbix-agent::install_source to install zabbbix from source' do
    chef_source = ChefSpec::ServerRunner.new do |node|
      node.set['zabbix']['agent']['install_method'] = 'source'
    end.converge('zabbix-agent::default')

    expect(chef_source).to include_recipe('zabbix-agent::install_source')
    expect(chef_source).to create_remote_file("#{Chef::Config[:file_cache_path]}/zabbix-2.2.7.tar.gz")
    get_file = chef_source.remote_file("#{Chef::Config[:file_cache_path]}/zabbix-2.2.7.tar.gz")
    expect(get_file).to notify('bash[install_program]').to(:run).immediately
  end

  it 'creates the template /etc/zabbix/zabbix_agentd.conf with the default configuration' do
    expect(chef_run).to create_template('zabbix_agentd.conf').with(
      path:   '/etc/zabbix/zabbix_agentd.conf',
      user:   'root',
      group:  'root',
      mode:   '644'
    )
  end

  it 'starts and enables the zabbix-agent service with an explicit action' do
    expect(chef_run).to start_service('zabbix-agent')
    expect(chef_run).to enable_service('zabbix-agent')
  end
end
