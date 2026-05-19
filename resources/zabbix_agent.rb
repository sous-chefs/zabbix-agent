# frozen_string_literal: true

provides :zabbix_agent
unified_mode true

default_action %i(create start)

include ZabbixAgent::Helpers

property :instance, String, name_property: true
property :install_method, String, equal_to: %w(package source prebuild chocolatey skip), default: 'package'
property :repo_version, String, default: '7.0'
property :version, String, default: '7.0.26'
property :package_name, String, default: 'zabbix-agent'
property :package_version, [String, nil]
property :repo_uri, [String, nil], default: lazy { default_repo_uri(repo_version) }
property :repo_key, [String, nil], default: lazy { default_repo_key }
property :source_url, [String, nil], default: lazy { default_source_url(version) }
property :source_checksum, [String, nil]
property :prebuild_url, [String, nil], default: lazy { default_prebuild_url(version, prebuild_arch) }
property :prebuild_checksum, [String, nil]
property :prebuild_arch, String, default: lazy { default_arch }
property :configure_options, Array, default: %w(--with-libcurl --with-libpcre2)
property :etc_dir, String, default: lazy { default_etc_dir }
property :install_dir, String, default: lazy { default_install_dir }
property :include_dir, String, default: lazy { ::File.join(etc_dir, 'zabbix_agentd.d') }
property :config_file, String, default: lazy { ::File.join(etc_dir, 'zabbix_agentd.conf') }
property :userparams_config_file, String, default: lazy { ::File.join(include_dir, 'user_params.conf') }
property :scripts_dir, String, default: lazy { default_scripts_dir }
property :log_dir, String, default: lazy { default_log_dir }
property :run_dir, String, default: lazy { default_run_dir }
property :lock_dir, String, default: '/var/lock/subsys'
property :pid_file, String, default: lazy { ::File.join(run_dir, 'zabbix_agentd.pid') }
property :user, String, default: lazy { default_user }
property :group, String, default: lazy { default_group }
property :shell, String, default: '/bin/bash'
property :uid, [Integer, nil], default: nil
property :gid, [Integer, String, nil], default: nil
property :config, Hash, default: lazy {
  {
    'Alias' => nil,
    'AllowRoot' => windows? ? nil : '0',
    'BufferSend' => '5',
    'BufferSize' => '100',
    'DebugLevel' => '3',
    'EnableRemoteCommands' => '1',
    'HostMetadata' => nil,
    'Hostname' => nil,
    'HostnameItem' => windows? ? nil : 'system.run[hostname -f]',
    'Include' => ::File.join(include_dir, '*.conf'),
    'ListenIP' => '0.0.0.0',
    'ListenPort' => '10050',
    'LogType' => 'system',
    'LogFile' => nil,
    'LogFileSize' => '1',
    'LogRemoteCommands' => '0',
    'MaxLinesPerSecond' => '100',
    'PidFile' => windows? ? nil : pid_file,
    'RefreshActiveChecks' => '120',
    'Server' => 'zabbix',
    'ServerActive' => nil,
    'SourceIP' => nil,
    'StartAgents' => '3',
    'Timeout' => '3',
    'UnsafeUserParameters' => '0',
  }.compact
}
property :user_parameters, Array, default: []
property :service_name, String, default: 'zabbix-agent'
property :service_actions, Array, default: %i(enable start)

action_class do
  include ZabbixAgent::Helpers

  def install_common
    if windows?
      user new_resource.user do
        not_if { new_resource.user == 'Administrator' }
      end
    else
      group new_resource.group do
        gid new_resource.gid if new_resource.gid
        system true
      end

      user new_resource.user do
        shell new_resource.shell
        uid new_resource.uid if new_resource.uid
        gid new_resource.gid || new_resource.group
        system true
        manage_home true
      end
    end

    directory new_resource.install_dir do
      owner new_resource.user unless windows? && new_resource.user == 'Administrator'
      group new_resource.group unless windows?
      mode '0755'
      recursive true
    end

    directory new_resource.etc_dir do
      owner(windows? && new_resource.user != 'Administrator' ? new_resource.user : 'root')
      group 'root' unless windows?
      mode '0755' unless windows?
      rights :read, 'Everyone', applies_to_children: true if windows?
      recursive true
    end

    directory new_resource.scripts_dir do
      owner(windows? && new_resource.user != 'Administrator' ? new_resource.user : 'root')
      group 'root' unless windows?
      mode '0755' unless windows?
      rights :read, 'Everyone', applies_to_children: true if windows?
      recursive true
    end

    directory new_resource.include_dir do
      owner(windows? && new_resource.user != 'Administrator' ? new_resource.user : 'root')
      group 'root' unless windows?
      mode '0755' unless windows?
      rights :read, 'Everyone', applies_to_children: true if windows?
      recursive true
      notifies :restart, "service[#{new_resource.service_name}]", :delayed if service_manageable?
    end

    [new_resource.log_dir, (windows? ? nil : new_resource.run_dir)].compact.each do |dir|
      directory dir do
        owner new_resource.user unless windows? && new_resource.user == 'Administrator'
        group new_resource.group unless windows?
        mode '0755' unless windows?
        recursive true
        not_if { !windows? && ::File.exist?(dir) && ::File.world_writable?(dir) }
      end
    end
  end

  def install_package_method
    case node['platform_family']
    when 'windows'
      chocolatey_package new_resource.package_name do
        version new_resource.package_version if new_resource.package_version
        action :install
      end
    when 'debian'
      apt_repository 'zabbix' do
        uri new_resource.repo_uri
        components ['main']
        key new_resource.repo_key
      end

      package new_resource.package_name do
        version new_resource.package_version if new_resource.package_version
        options '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'
        action :upgrade
      end
    when 'rhel', 'amazon'
      yum_repository 'zabbix' do
        repositoryid 'zabbix'
        description 'Zabbix Official Repository'
        baseurl new_resource.repo_uri
        gpgkey new_resource.repo_key
        sslverify false
        action :create
      end

      package new_resource.package_name do
        version new_resource.package_version if new_resource.package_version
        action :upgrade
      end
    else
      raise "Unsupported platform family for package install: #{node['platform_family']}"
    end
  end

  def install_source_method
    package source_dependencies unless source_dependencies.empty?

    build_essential 'install build tools'

    archive = "#{Chef::Config[:file_cache_path]}/zabbix-#{new_resource.version}.tar.gz"

    remote_file archive do
      source new_resource.source_url
      checksum new_resource.source_checksum if new_resource.source_checksum
      mode '0644'
    end

    source_dir = "#{new_resource.install_dir}/zabbix-#{new_resource.version}"
    options = new_resource.configure_options.reject { |option| option.match?(/\s*--prefix(\s|=).+/) }

    execute 'build zabbix agent from source' do
      cwd new_resource.install_dir
      command "tar -zxf #{archive} && cd #{source_dir} && ./configure --enable-agent --prefix=#{new_resource.install_dir} #{options.join(' ')} && make install && touch already_built"
      creates "#{new_resource.install_dir}/sbin/zabbix_agentd"
    end
  end

  def install_prebuild_method
    archive = "#{Chef::Config[:file_cache_path]}/zabbix_agent-#{new_resource.version}-linux-3.0-#{new_resource.prebuild_arch}-static.tar.gz"

    remote_file archive do
      source new_resource.prebuild_url
      checksum new_resource.prebuild_checksum if new_resource.prebuild_checksum
      mode '0644'
    end

    archive_file archive do
      destination new_resource.install_dir
      overwrite true
      action :extract
      not_if { ::File.exist?(::File.join(new_resource.install_dir, 'sbin/zabbix_agentd')) }
    end
  end

  def install_selected_method
    case new_resource.install_method
    when 'package', 'chocolatey'
      install_package_method
    when 'source'
      install_source_method
    when 'prebuild'
      install_prebuild_method
    when 'skip'
      log 'Skip the installation of zabbix agent' do
        level :info
      end
    end
  end

  def configure_agent
    template new_resource.config_file do
      source 'zabbix_agentd.conf.erb'
      cookbook 'zabbix-agent'
      owner 'root' unless windows?
      group 'root' unless windows?
      mode '0644' unless windows?
      variables config: new_resource.config
      notifies :restart, "service[#{new_resource.service_name}]", :delayed if service_manageable?
    end

    template new_resource.userparams_config_file do
      source 'user_params.conf.erb'
      cookbook 'zabbix-agent'
      owner 'root' unless windows?
      group 'root' unless windows?
      mode '0644' unless windows?
      variables user_parameters: new_resource.user_parameters
      notifies :restart, "service[#{new_resource.service_name}]", :delayed if service_manageable?
      not_if { new_resource.user_parameters.empty? }
    end
  end

  def service_manageable?
    windows? || new_resource.install_method == 'package'
  end

  def define_service(service_action = new_resource.service_actions)
    return unless service_manageable?

    service new_resource.service_name do
      service_name 'Zabbix Agent' if windows?
      pattern 'zabbix_agentd' unless windows?
      if windows?
        supports restart: true
      else
        supports status: true, start: true, stop: true, restart: true
      end
      action service_action
    end
  end
end

action :create do
  install_common
  install_selected_method
  configure_agent
  define_service
end

action :start do
  define_service
end

action :stop do
  define_service [:stop, :disable]
end

action :restart do
  define_service :restart
end

action :remove do
  service new_resource.service_name do
    service_name 'Zabbix Agent' if windows?
    action [:stop, :disable]
    ignore_failure true
    only_if { service_manageable? }
  end

  package new_resource.package_name do
    action :remove
    only_if { new_resource.install_method == 'package' && !windows? }
  end

  chocolatey_package new_resource.package_name do
    action :remove
    only_if { windows? && %w(package chocolatey).include?(new_resource.install_method) }
  end

  apt_repository 'zabbix' do
    action :remove
    only_if { platform_family?('debian') && new_resource.install_method == 'package' }
  end

  yum_repository 'zabbix' do
    action :remove
    only_if { platform_family?('rhel', 'amazon') && new_resource.install_method == 'package' }
  end

  file new_resource.config_file do
    action :delete
  end

  file new_resource.userparams_config_file do
    action :delete
  end

  [new_resource.include_dir, new_resource.scripts_dir, new_resource.etc_dir, new_resource.log_dir, (windows? ? nil : new_resource.run_dir)].compact.each do |dir|
    directory dir do
      recursive true
      action :delete
    end
  end
end
