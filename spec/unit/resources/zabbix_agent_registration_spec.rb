# frozen_string_literal: true

require 'spec_helper'

describe 'zabbix_agent_registration' do
  platform 'ubuntu', '24.04'

  recipe do
    zabbix_agent_registration 'web-01' do
      server_url 'https://zabbix.example.com/api_jsonrpc.php'
      api_user 'api-user'
      api_password 'secret'
      groups ['linux']
      templates ['Linux by Zabbix agent']
      ip_address '192.0.2.10'
      fqdn 'web-01.example.com'
    end
  end

  it { is_expected.to create_zabbix_agent_registration('web-01') }
end
