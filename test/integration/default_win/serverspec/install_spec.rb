require 'spec_helper'

#describe command('choco list --localonly') do
#  its(:stdout) { should match %r{zabbix-agent}}
#end

describe file('C:\zabbix\agent') do
  it { should_not be_directory }
end

describe file('C:\programdata\zabbix\scripts') do
  it { should be_directory }
end

describe file('C:\programdata\zabbix\zabbix_agentd.d') do
  it { should be_directory }
end

describe file('C:\programdata\zabbix\log') do
  it { should be_directory }
end
