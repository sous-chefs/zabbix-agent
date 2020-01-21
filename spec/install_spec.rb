require 'spec_helper'

describe 'zabbix-agent install method tests' do
  context 'with install_method=prebuild it' do
    cached(:chef_prebuild) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu') do |node|
        node.override['zabbix']['agent']['install_method'] = 'prebuild'
        node.override['zabbix']['agent']['init_style'] = 'sysvinit'
      end.converge('zabbix-agent::default')
    end
    # changed node['zabbix']['agent']['install_method'] = prebuild
    it 'includes zabbix-agent::install_prebuild to install zabbbix from prebuild tar files' do
      expect(chef_prebuild).to include_recipe('zabbix-agent::install_prebuild')
    end

    it "gets the zabbix binary prebuild archive from 'http://www.zabbix.com/downloads/ and puts it  #{Chef::Config[:file_cache_path]}/zabbix_agents_3.0.9.linux2_6.amd64.tar.gz" do
      expect(chef_prebuild).to create_remote_file("#{Chef::Config[:file_cache_path]}/zabbix_agents_3.0.9.linux2_6.amd64.tar.gz").with(
        source: 'http://www.zabbix.com/downloads/3.0.9/zabbix_agents_3.0.9.linux2_6.amd64.tar.gz'
      )
    end

    it 'notifies the bash install_program when the archive is downloaded' do
      get_file = chef_prebuild.remote_file("#{Chef::Config[:file_cache_path]}/zabbix_agents_3.0.9.linux2_6.amd64.tar.gz")
      expect(get_file).to notify('bash[install_program]').to(:run).immediately
    end

    it 'does not run the install program if the archive is not downloaded' do
      expect(chef_prebuild).to_not run_bash('install_program')
    end

    it 'creates the zabbix-agent init script' do
      expect(chef_prebuild).to create_template('/etc/init.d/zabbix-agent')
    end

    it 'renders the zabbix-agent init script file with content from ./spec/rendered_templates/zabbix-agent' do
      zabbix_agent = File.read('./spec/rendered_templates/zabbix-agent')
      expect(chef_prebuild).to render_file('/etc/init.d/zabbix-agent').with_content(zabbix_agent)
    end
  end

  context 'with install_method=source it' do
    cached(:chef_source) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '6') do |node|
        node.override['zabbix']['agent']['install_method'] = 'source'
        node.override['zabbix']['agent']['init_style'] = 'sysvinit'
      end.converge('zabbix-agent::default')
    end
    # changed node['zabbix']['agent']['install_method'] = source
    it 'includes zabbix-agent::install_source to install zabbbix from source' do
      expect(chef_source).to include_recipe('zabbix-agent::install_source')
    end

    it "gets the zabbix source archive from http://downloads.sourceforge.net and puts it in #{Chef::Config[:file_cache_path]}/zabbix-3.0.9.tar.gz" do
      expect(chef_source).to create_remote_file("#{Chef::Config[:file_cache_path]}/zabbix-3.0.9.tar.gz").with(
        source: 'http://downloads.sourceforge.net/project/zabbix//ZABBIX%20Latest%20Stable/3.0.9/zabbix-3.0.9.tar.gz'
      )
    end

    it 'the download of the zabbix source archive zabbix-3.0.9.tar.gz notifies the bash install_program' do
      get_file = chef_source.remote_file("#{Chef::Config[:file_cache_path]}/zabbix-3.0.9.tar.gz")
      expect(get_file).to notify('bash[install_program]').to(:run).immediately
    end

    it 'creates the zabbix-agent init script' do
      expect(chef_source).to create_template('/etc/init.d/zabbix-agent')
    end

    it 'renders the zabbix-agent init script file with content from ./spec/rendered_templates/zabbix-agent-rh' do
      zabbix_agent = File.read('./spec/rendered_templates/zabbix-agent-rh')
      expect(chef_source).to render_file('/etc/init.d/zabbix-agent').with_content(zabbix_agent)
    end
  end

  context 'with install_method=source and on CentOS platform it' do
    cached(:chef_source) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '6') do |node|
        node.override['zabbix']['agent']['install_method'] = 'source'
      end.converge('zabbix-agent::install_source')
    end

    it 'installs the packages curl-devel, openssl-devel, and redhat-lsb' do
      expect(chef_source).to install_package(%w(curl-devel openssl-devel redhat-lsb))
    end

    it "gets the zabbix source archive from http://downloads.sourceforge.net and puts it in #{Chef::Config[:file_cache_path]}/zabbix-3.0.9.tar.gz" do
      expect(chef_source).to create_remote_file("#{Chef::Config[:file_cache_path]}/zabbix-3.0.9.tar.gz").with(
        source: 'http://downloads.sourceforge.net/project/zabbix//ZABBIX%20Latest%20Stable/3.0.9/zabbix-3.0.9.tar.gz'
      )
    end
  end

  context 'with install_method=source and on Ubuntu 16.04 it' do
    cached(:chef_source) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
        node.override['zabbix']['agent']['install_method'] = 'source'
      end.converge('zabbix-agent::install_source')
    end

    it 'installs the packages libcurl3 and libcurl4-openssl-dev' do
      expect(chef_source).to install_package(%w(libcurl3 libcurl4-openssl-dev))
    end
  end

  context 'with install_method=source and on Ubuntu 18.04 it' do
    cached(:chef_source) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '18.04') do |node|
        node.override['zabbix']['agent']['install_method'] = 'source'
      end.converge('zabbix-agent::install_source')
    end

    it 'installs the packages libcurl4 and libcurl4-openssl-dev' do
      expect(chef_source).to install_package(%w(libcurl4 libcurl4-openssl-dev))
    end
  end

  context 'with install_method=source and on Debian 9 it' do
    cached(:chef_source) do
      ChefSpec::ServerRunner.new(platform: 'debian', version: '9') do |node|
        node.override['zabbix']['agent']['install_method'] = 'source'
      end.converge('zabbix-agent::install_source')
    end

    it 'installs the packages libcurl3 and libcurl4-openssl-dev' do
      expect(chef_source).to install_package(%w(libcurl3 libcurl4-openssl-dev))
    end
  end

  context 'with install_method=source and on Debian 10 it' do
    cached(:chef_source) do
      ChefSpec::ServerRunner.new(platform: 'debian', version: '10') do |node|
        node.override['zabbix']['agent']['install_method'] = 'source'
      end.converge('zabbix-agent::install_source')
    end

    it 'installs the packages libcurl4 and libcurl4-openssl-dev' do
      expect(chef_source).to install_package(%w(libcurl4 libcurl4-openssl-dev))
    end
  end
end
