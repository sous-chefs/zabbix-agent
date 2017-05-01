config_file = if os.windows?
                'C:\programdata\zabbix\zabbix_agentd.conf'
              else
                '/etc/zabbix/zabbix_agentd.conf'
              end

describe file(config_file) do
  it { should be_file }
end
