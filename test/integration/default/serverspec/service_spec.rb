require 'spec_helper'

describe service('zabbix_agentd') do
#  it { should be_enabled } unless os[:family] == 'ubuntu'
  it { should be_running }
end
