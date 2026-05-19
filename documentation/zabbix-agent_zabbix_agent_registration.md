# zabbix_agent_registration

Registers a host with a Zabbix server through libzabbix-compatible Chef resources supplied by a
wrapper cookbook.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the host registration |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `host_name` | String | name property | Zabbix host name |
| `server_url` | String | required | Zabbix JSON-RPC endpoint |
| `api_user` | String | required | API username |
| `api_password` | String | required | API password |
| `groups` | Array | `['chef-agent']` | Zabbix group names |
| `templates` | Array | `[]` | Zabbix template names |
| `interfaces` | Array | `['zabbix_agent']` | Interface types to register |
| `ip_address` | String | required | Host IP address |
| `fqdn` | String | required | Host DNS name |
| `agent_port` | String, Integer | `'10050'` | Agent port |
| `jmx_port` | String, Integer | `'10052'` | JMX port |
| `snmp_port` | String, Integer | `'161'` | SNMP port |

## Examples

```ruby
zabbix_agent_registration 'web-01' do
  server_url 'https://zabbix.example.com/api_jsonrpc.php'
  api_user 'api-user'
  api_password 'secret'
  groups ['linux']
  templates ['Linux by Zabbix agent']
  ip_address '192.0.2.10'
  fqdn 'web-01.example.com'
end
```
