# frozen_string_literal: true

provides :zabbix_agent_registration
unified_mode true

default_action :create

property :host_name, String, name_property: true
property :server_url, String, required: true
property :api_user, String, required: true
property :api_password, String, required: true, sensitive: true
property :groups, Array, default: ['chef-agent']
property :templates, Array, default: []
property :interfaces, Array, default: ['zabbix_agent']
property :ip_address, String, required: true
property :fqdn, String, required: true
property :agent_port, [String, Integer], default: '10050'
property :jmx_port, [String, Integer], default: '10052'
property :snmp_port, [String, Integer], default: '161'

action_class do
  def interface_definitions
    {
      zabbix_agent: {
        type: 1,
        main: 1,
        useip: 1,
        ip: new_resource.ip_address,
        dns: new_resource.fqdn,
        port: new_resource.agent_port,
      },
      jmx: {
        type: 4,
        main: 1,
        useip: 1,
        ip: new_resource.ip_address,
        dns: new_resource.fqdn,
        port: new_resource.jmx_port,
      },
      snmp: {
        type: 2,
        main: 1,
        useip: 1,
        ip: new_resource.ip_address,
        dns: new_resource.fqdn,
        port: new_resource.snmp_port,
      },
    }
  end

  def selected_interfaces
    new_resource.interfaces.filter_map do |interface|
      interface_definitions[interface.to_sym]
    end
  end
end

action :create do
  libzabbix_host new_resource.host_name do
    create_missing_groups true
    server_connection(
      url: new_resource.server_url,
      user: new_resource.api_user,
      password: new_resource.api_password
    )
    parameters(
      host: new_resource.host_name,
      groupNames: new_resource.groups,
      templates: new_resource.templates,
      interfaces: selected_interfaces
    )
    action :create_or_update
  end
end
