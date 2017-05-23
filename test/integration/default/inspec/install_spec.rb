unless os.windows?
  describe user('zabbix') do
    it { should exist }
    its('group') { should eq 'zabbix' }
  end

  describe group('zabbix') do
    it { should exist }
  end
end

zabbix_config_dir = if os.windows?
                      'C:/programdata/zabbix'
                    else
                      '/etc/zabbix'
                    end
describe file(File.join(zabbix_config_dir, 'scripts')) do
  it { should be_directory }
end

describe file(File.join(zabbix_config_dir, 'zabbix_agentd.d')) do
  it { should be_directory }
end

zabbix_log_dir = if os.windows?
                   'C:/programdata/zabbix/log'
                 else
                   '/var/log/zabbix'
                 end
describe file(zabbix_log_dir) do
  it { should be_directory }
end

if os.windows?
  describe file('C:\zabbix\agent') do
    it { should_not be_directory }
  end
end
