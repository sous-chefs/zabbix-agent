# frozen_string_literal: true

require 'spec_helper'

describe 'zabbix_agent' do
  step_into :zabbix_agent

  context 'on ubuntu with package install' do
    platform 'ubuntu', '24.04'

    recipe do
      zabbix_agent 'default' do
        config(
          'Server' => '127.0.0.1',
          'ListenPort' => '10050'
        )
        user_parameters ['test.ping,echo 1']
      end
    end

    it { is_expected.to create_group('zabbix').with(system: true) }
    it { is_expected.to create_user('zabbix').with(shell: '/bin/bash', system: true, manage_home: true) }
    it { is_expected.to create_directory('/etc/zabbix') }
    it { is_expected.to create_directory('/etc/zabbix/scripts') }
    it { is_expected.to create_directory('/etc/zabbix/zabbix_agentd.d') }
    it { is_expected.to create_directory('/var/log/zabbix') }
    it { is_expected.to create_directory('/var/run/zabbix') }

    it do
      is_expected.to add_apt_repository('zabbix').with(
        uri: 'https://repo.zabbix.com/zabbix/7.0/ubuntu',
        components: ['main'],
        key: ['https://repo.zabbix.com/zabbix-official-repo.key']
      )
    end

    it { is_expected.to upgrade_package('zabbix-agent') }

    it do
      is_expected.to create_template('/etc/zabbix/zabbix_agentd.conf').with(
        source: 'zabbix_agentd.conf.erb',
        user: 'root',
        group: 'root',
        mode: '0644'
      )
    end

    it { is_expected.to render_file('/etc/zabbix/zabbix_agentd.conf').with_content(/^Server=127\.0\.0\.1$/) }
    it { is_expected.to render_file('/etc/zabbix/zabbix_agentd.conf').with_content(/^ListenPort=10050$/) }
    it { is_expected.to create_template('/etc/zabbix/zabbix_agentd.d/user_params.conf') }
    it { is_expected.to render_file('/etc/zabbix/zabbix_agentd.d/user_params.conf').with_content(/^UserParameter=test\.ping,echo 1$/) }
    it { is_expected.to enable_service('zabbix-agent') }
    it { is_expected.to start_service('zabbix-agent') }
  end

  context 'on almalinux with package install' do
    platform 'almalinux', '9'

    recipe do
      zabbix_agent 'default'
    end

    it do
      is_expected.to create_yum_repository('zabbix').with(
        repositoryid: 'zabbix',
        description: 'Zabbix Official Repository',
        baseurl: 'https://repo.zabbix.com/zabbix/7.0/rhel/$releasever/$basearch/',
        gpgkey: 'https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
        sslverify: false
      )
    end

    it { is_expected.to upgrade_package('zabbix-agent') }
  end

  context 'with source install' do
    platform 'ubuntu', '24.04'

    recipe do
      zabbix_agent 'source' do
        install_method 'source'
      end
    end

    it { is_expected.to install_package(%w(libcurl4 libcurl4-openssl-dev libpcre2-dev pkg-config tar)) }
    it { is_expected.to update_apt_update('update package lists before source install') }
    it { is_expected.to install_build_essential('install build tools') }
    it { is_expected.to create_remote_file("#{Chef::Config[:file_cache_path]}/zabbix-7.0.26.tar.gz") }
    it { is_expected.to run_execute('build zabbix agent from source') }
    it { is_expected.not_to enable_service('zabbix-agent') }
    it { is_expected.not_to start_service('zabbix-agent') }
  end

  context 'with source install on almalinux' do
    platform 'almalinux', '9'

    recipe do
      zabbix_agent 'source' do
        install_method 'source'
      end
    end

    it { is_expected.to install_package(%w(curl-devel openssl-devel pcre2-devel pkgconf-pkg-config tar)) }
    it { is_expected.not_to install_package('redhat-lsb') }
  end

  context 'with prebuild install' do
    platform 'ubuntu', '24.04'

    recipe do
      zabbix_agent 'prebuild' do
        install_method 'prebuild'
      end
    end

    it { is_expected.to create_remote_file("#{Chef::Config[:file_cache_path]}/zabbix_agent-7.0.26-linux-3.0-amd64-static.tar.gz") }
    it { is_expected.to extract_archive_file("#{Chef::Config[:file_cache_path]}/zabbix_agent-7.0.26-linux-3.0-amd64-static.tar.gz").with(destination: '/opt/zabbix') }
    it { is_expected.not_to install_package('redhat-lsb') }
    it { is_expected.not_to enable_service('zabbix-agent') }
    it { is_expected.not_to start_service('zabbix-agent') }
  end

  context 'with skip install' do
    platform 'ubuntu', '24.04'

    recipe do
      zabbix_agent 'skip' do
        install_method 'skip'
      end
    end

    it { is_expected.to write_log('Skip the installation of zabbix agent') }
    it { is_expected.to create_template('/etc/zabbix/zabbix_agentd.conf') }
  end

  context 'with remove action' do
    platform 'ubuntu', '24.04'

    recipe do
      zabbix_agent 'default' do
        action :remove
      end
    end

    it { is_expected.to stop_service('zabbix-agent') }
    it { is_expected.to disable_service('zabbix-agent') }
    it { is_expected.to remove_package('zabbix-agent') }
    it { is_expected.to remove_apt_repository('zabbix') }
    it { is_expected.to delete_file('/etc/zabbix/zabbix_agentd.conf') }
    it { is_expected.to delete_file('/etc/zabbix/zabbix_agentd.d/user_params.conf') }
  end
end
