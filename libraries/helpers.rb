# frozen_string_literal: true

module ZabbixAgent
  module Helpers
    def windows?
      node['platform_family'] == 'windows'
    end

    def default_etc_dir
      windows? ? ::File.join(ENV.fetch('PROGRAMDATA', 'C:/ProgramData'), 'zabbix') : '/etc/zabbix'
    end

    def default_install_dir
      windows? ? default_etc_dir : '/opt/zabbix'
    end

    def default_log_dir
      windows? ? ::File.join(default_etc_dir, 'log') : '/var/log/zabbix'
    end

    def default_run_dir
      '/var/run/zabbix'
    end

    def default_scripts_dir
      windows? ? ::File.join(default_etc_dir, 'scripts') : '/etc/zabbix/scripts'
    end

    def default_user
      windows? ? 'Administrator' : 'zabbix'
    end

    def default_group
      windows? ? 'Administrators' : default_user
    end

    def default_repo_uri(repo_version)
      case node['platform_family']
      when 'debian'
        "https://repo.zabbix.com/zabbix/#{repo_version}/#{node['platform']}"
      when 'rhel', 'amazon'
        "https://repo.zabbix.com/zabbix/#{repo_version}/rhel/$releasever/$basearch/"
      end
    end

    def default_repo_key
      case node['platform_family']
      when 'debian'
        'https://repo.zabbix.com/zabbix-official-repo.key'
      when 'rhel', 'amazon'
        'https://repo.zabbix.com/RPM-GPG-KEY-ZABBIX'
      end
    end

    def default_source_url(version)
      "https://cdn.zabbix.com/zabbix/sources/stable/#{version.split('.').first(2).join('.')}/zabbix-#{version}.tar.gz"
    end

    def default_prebuild_url(version, arch)
      "https://cdn.zabbix.com/zabbix/binaries/stable/#{version.split('.').first(2).join('.')}/#{version}/zabbix_agent-#{version}-linux-3.0-#{arch}-static.tar.gz"
    end

    def default_arch
      node.dig('kernel', 'machine') == 'x86_64' ? 'amd64' : 'i386'
    end

    def source_dependencies
      case node['platform_family']
      when 'debian'
        if (platform?('debian') && node['platform_version'].to_i >= 10) ||
           (platform?('ubuntu') && node['platform_version'].to_i >= 18)
          %w(libcurl4 libcurl4-openssl-dev libpcre2-dev pkg-config)
        else
          %w(libcurl3 libcurl4-openssl-dev libpcre3-dev pkg-config)
        end
      when 'rhel', 'amazon'
        %w(curl-devel openssl-devel pcre2-devel pkgconf-pkg-config redhat-lsb)
      else
        []
      end
    end
  end
end
