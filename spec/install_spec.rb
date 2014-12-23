require 'spec_helper'

describe 'zabbix-agent' do
  context 'install_method=prebuild' do
    cached(:chef_prebuild) do
      ChefSpec::ServerRunner.new do |node|
        node.set['zabbix']['agent']['install_method'] = 'prebuild'
      end.converge('zabbix-agent::default')
    end
    # changed node['zabbix']['agent']['install_method'] = prebuild
    it 'includes zabbix-agent::install_prebuild to install zabbbix from prebuild tar files' do
      expect(chef_prebuild).to include_recipe('zabbix-agent::install_prebuild')
    end

    it 'gets the zabbix archive zabbix-2.2.7.tar.gz' do
      expect(chef_prebuild).to create_remote_file("#{Chef::Config[:file_cache_path]}/zabbix_agents_2.2.7.linux2_6.i386.tar.gz")
    end

    it 'notifies the bash install_program when the archive is downloaded' do
      get_file = chef_prebuild.remote_file("#{Chef::Config[:file_cache_path]}/zabbix_agents_2.2.7.linux2_6.i386.tar.gz")
      expect(get_file).to notify('bash[install_program]').to(:run).immediately
    end
  end

  context 'install_method=source' do
    cached(:chef_source) do
      ChefSpec::ServerRunner.new(:platform => 'centos', :version => '6.5') do |node|
        node.set['zabbix']['agent']['install_method'] = 'source'
      end.converge('zabbix-agent::install_source')
    end
    # changed node['zabbix']['agent']['install_method'] = source
    it 'includes zabbix-agent::install_source to install zabbbix from source' do
      expect(chef_source).to include_recipe('zabbix-agent::install_source')
    end

    it 'includes the build-essential cookbook' do
      expect(chef_source).to include_recipe('build-essential')
    end

    it 'gets the zabbix archive zabbix-2.2.7.tar.gz' do
      expect(chef_source).to create_remote_file("#{Chef::Config[:file_cache_path]}/zabbix-2.2.7.tar.gz")
    end

    it 'the zabbix archive zabbix-2.2.7.tar.gz notifies the bash install_program' do
      get_file = chef_source.remote_file("#{Chef::Config[:file_cache_path]}/zabbix-2.2.7.tar.gz")
      expect(get_file).to notify('bash[install_program]').to(:run).immediately
    end
  end
end
