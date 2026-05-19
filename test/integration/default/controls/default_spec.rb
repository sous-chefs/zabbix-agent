# frozen_string_literal: true

control 'zabbix-agent-binary-01' do
  impact 1.0
  title 'Zabbix agent binary is installed'

  describe file('/opt/zabbix/sbin/zabbix_agentd') do
    it { should exist }
    it { should be_executable }
  end
end

control 'zabbix-agent-config-01' do
  impact 1.0
  title 'Zabbix agent configuration exists'

  describe file('/etc/zabbix/zabbix_agentd.conf') do
    it { should exist }
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should match(/^Server=127\.0\.0\.1$/) }
    its('content') { should match(/^ListenPort=10050$/) }
  end
end

control 'zabbix-agent-userparams-01' do
  impact 0.7
  title 'Zabbix agent user parameters are rendered'

  describe file('/etc/zabbix/zabbix_agentd.d/user_params.conf') do
    it { should exist }
    its('content') { should match(/^UserParameter=test\.ping,echo 1$/) }
  end
end
