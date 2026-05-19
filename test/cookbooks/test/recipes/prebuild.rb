# frozen_string_literal: true

zabbix_agent 'prebuild' do
  install_method 'prebuild'
  config(
    'AllowRoot' => '0',
    'DebugLevel' => '3',
    'EnableRemoteCommands' => '1',
    'HostnameItem' => 'system.run[hostname -f]',
    'Include' => '/etc/zabbix/zabbix_agentd.d/*.conf',
    'ListenIP' => '0.0.0.0',
    'ListenPort' => '10050',
    'LogFile' => '/var/log/zabbix/zabbix_agentd.log',
    'PidFile' => '/var/run/zabbix/zabbix_agentd.pid',
    'Server' => '127.0.0.1',
    'ServerActive' => '127.0.0.1',
    'Timeout' => '3'
  )
  action %i(create start)
end
