service_name = if os.windows?
                 'Zabbix Agent'
               else
                 'zabbix-agent'
               end
describe service(service_name) do
  it { should be_enabled }
  it { should be_running }
end
