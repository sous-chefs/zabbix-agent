config_file = if os.windows?
                'C:\programdata\zabbix\zabbix_agentd.conf'
              else
                '/etc/zabbix/zabbix_agentd.conf'
              end

describe file(config_file) do
  it { should be_file }
end

if os.windows?
  describe parse_config_file(config_file) do
    its('Include') { should eq 'C:\\ProgramData\\zabbix\\zabbix_agentd.d\\*.conf' } # wildcard paths need backslashes
  end
end
