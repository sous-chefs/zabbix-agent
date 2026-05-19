# zabbix_agent

Installs and configures the Zabbix agent. Package installs manage the package-supplied service
with Chef's built-in `service` resource; source and prebuilt installs do not create or override a
system service unit.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Installs and configures the agent |
| `:start` | Enables and starts the package-supplied service |
| `:stop` | Stops and disables the package-supplied service |
| `:restart` | Restarts the package-supplied service |
| `:remove` | Removes package, repository, and configuration artifacts |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `instance` | String | name property | Resource instance name |
| `install_method` | String | `'package'` | `package`, `source`, `prebuild`, `chocolatey`, or `skip` |
| `repo_version` | String | `'7.0'` | Zabbix repository major/minor version |
| `version` | String | `'7.0.26'` | Source or prebuilt archive version |
| `package_name` | String | `'zabbix-agent'` | Package to install |
| `package_version` | String, nil | `nil` | Optional package version pin |
| `repo_uri` | String, nil | platform default | Repository URL |
| `repo_key` | String, nil | platform default | Repository GPG key URL |
| `source_url` | String, nil | official source URL | Source tarball URL |
| `source_checksum` | String, nil | `nil` | Optional source tarball checksum |
| `prebuild_url` | String, nil | official static archive URL | Static archive URL |
| `prebuild_checksum` | String, nil | `nil` | Optional static archive checksum |
| `prebuild_arch` | String | detected architecture | Static archive architecture |
| `configure_options` | Array | `['--with-libcurl', '--with-libpcre2']` | Source build options |
| `etc_dir` | String | `'/etc/zabbix'` | Configuration directory |
| `install_dir` | String | `'/opt/zabbix'` | Source/prebuilt installation directory |
| `include_dir` | String | `'/etc/zabbix/zabbix_agentd.d'` | Included config directory |
| `config_file` | String | `'/etc/zabbix/zabbix_agentd.conf'` | Main config file path |
| `userparams_config_file` | String | include dir path | User parameters config file path |
| `scripts_dir` | String | `'/etc/zabbix/scripts'` | Scripts directory |
| `log_dir` | String | `'/var/log/zabbix'` | Log directory |
| `run_dir` | String | `'/var/run/zabbix'` | Runtime directory |
| `pid_file` | String | run dir path | PID file path |
| `user` | String | `'zabbix'` | Service user |
| `group` | String | `'zabbix'` | Service group |
| `shell` | String | `'/bin/bash'` | Service user shell |
| `uid` | Integer, nil | `nil` | Optional service user UID |
| `gid` | Integer, String, nil | `nil` | Optional service group GID |
| `config` | Hash | Zabbix defaults | Rendered `zabbix_agentd.conf` entries |
| `user_parameters` | Array | `[]` | Rendered `UserParameter` lines |
| `service_name` | String | `'zabbix-agent'` | Package-supplied service name |
| `service_actions` | Array | `[:enable, :start]` | Service actions applied during `:create` for package installs |

## Examples

### Package install

```ruby
zabbix_agent 'default' do
  config(
    'Server' => 'zabbix.example.com',
    'ServerActive' => 'zabbix.example.com'
  )
  action %i(create start)
end
```

### Source install

```ruby
zabbix_agent 'source' do
  install_method 'source'
  version '7.0.26'
  configure_options ['--with-libcurl', '--with-libpcre2']
  action :create
end
```

### Prebuilt static install

```ruby
zabbix_agent 'prebuilt' do
  install_method 'prebuild'
  version '7.0.26'
  prebuild_arch 'amd64'
  action :create
end
```
