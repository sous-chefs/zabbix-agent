# Migration

This release removes the legacy recipe and attribute public API. Use the `zabbix_agent` custom
resource in your wrapper cookbooks instead.

## Before

```ruby
node.default['zabbix']['agent']['conf']['Server'] = 'zabbix.example.com'
node.default['zabbix']['agent']['conf']['ServerActive'] = 'zabbix.example.com'
include_recipe 'zabbix-agent'
```

## After

```ruby
zabbix_agent 'default' do
  config(
    'Server' => 'zabbix.example.com',
    'ServerActive' => 'zabbix.example.com'
  )
  action %i(create start)
end
```

## Install Methods

The old `node['zabbix']['agent']['install_method']` attribute is now the `install_method` property:

```ruby
zabbix_agent 'source' do
  install_method 'source'
  version '7.0.26'
end
```

Supported values are `package`, `source`, `prebuild`, `chocolatey`, and `skip`.

## Configuration

The old `node['zabbix']['agent']['conf']` hash maps directly to the `config` property. User
parameters move from `node['zabbix']['agent']['user_parameter']` to `user_parameters`.

```ruby
zabbix_agent 'default' do
  config(
    'Server' => '127.0.0.1',
    'ListenPort' => '10050'
  )
  user_parameters ['test.ping,echo 1']
end
```
