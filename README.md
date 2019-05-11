# Chef Cookbook - zabbix-agent

[![Cookbook Version](https://img.shields.io/cookbook/v/zabbix-agent.svg)](https://supermarket.chef.io/cookbooks/zabbix-agent)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/zabbix-agent/master.svg)](https://circleci.com/gh/sous-chefs/zabbix-agent)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

This cookbook installs and configures the zabbix-agent with sane defaults and very minimal dependancies.

## Supported OS Distributions

- RHEL
- CentOS
- Ubuntu
- Debian
- Windows

Other similar versions will likely work as well but are not regularly tested.

## Useage

If you have a supported OS, internet access, and a searchable DNS alias for "zabbix" that will resolve to your zabbix server this cookbook will work with no additional changes.  Just include recipe[zabbix-agent] in your run_list.

Otherwise you will need to modify this to point to your zabbix server:

```ruby
node['zabbix']['agent']['servers'] = 'zabbix-server.yourdomain.com'
```

and

```ruby
default['zabbix']['agent']['package']['repo_uri'] = 'http://private-repo.yourdomain.com'
default['zabbix']['agent']['package']['repo_key'] = 'http://private-repo.yourdomain.com/path-to-repo.key'
```

or try one of the other install methods

### Other recomended cookbooks

- libzabbix - in development LWRPs to auto regester and setup monitoring for hosts
- zabbix-server - install configure Zabbix server - planned
- zabbix-web - install configure Zabbix web frontend - planned

### zabbix_agentd.conf file

All attributes in the zabbix_agentd.conf file can be controlled from the:

```ruby
node['zabbix']['agent']['conf']
```

attribute.  This will require a change in attribute naming for upgrades from 0.9.0.

```ruby
default['zabbix']['agent']['conf']['Timeout'] = '10'
```

or

```json
---
{
  "default_attributes": {
    "zabbix": {
      "agent": {
        "conf": {
          "Server": ["zabbix.example.com"],
          "Timeout": "10"
        }
      }
    }
  }
}
```

### Default Install, Configure and run zabbix agent

Install packages from repo.zabbix.com and run the Agent:

```json
{
  "run_list": [
    "recipe[zabbix-agent]"
  ]
}
```

### Selective Install or Install and Configure (don't start zabbix-agent)

Alternatively you can just install, or install and configure:

```json
{
  "run_list": [
    "recipe[zabbix-agent::install]"
  ]
}
```

or

```json
{
  "run_list": [
    "recipe[zabbix-agent::configure]"
  ]
}
```

### Attributes

Install Method options are:

```ruby
node['zabbix']['agent']['install_method'] = 'package' # Default
node['zabbix']['agent']['install_method'] = 'source'
node['zabbix']['agent']['install_method'] = 'prebuild'
node['zabbix']['agent']['install_method'] = 'cookbook_file' # not yet implemented
node['zabbix']['agent']['install_method'] = 'chocolatey' # Default for Windows

# skip is preferred if no internet access when provisioning
# zabbix agent was already installed via chef during image bake process
node['zabbix']['agent']['install_method'] = 'skip'
```

Version

```ruby
node['zabbix']['agent']['version'] # Default 3.0.9
```

Servers

```ruby
node['zabbix']['agent']['conf']['Server'] = ["Your_zabbix_server.com","secondaryserver.com"]
# defaults to zabbix
node['zabbix']['agent']['conf']['ServerActive'] = ["Your_zabbix_active_server.com"]
```

#### Package install

If you do not set any attributes you will get an install of zabbix agent version 3.0.9 with
what should be a working configuration if your DNS has aliases for zabbix.yourdomain.com and
your hosts search yourdomain.com.

#### Source install

If you do not specify source\_url attributes for agent it will be set to download the specified branch and version from the official Zabbix source repository. If you want to upgrade later, you need to either nil out the source\_url attributes or set them to the URL you wish to download from.

```ruby
node['zabbix']['agent']['version']
node['zabbix']['agent']['configure_options']
```

to install an alternative branch or tar file you can specify it here

```ruby
node['zabbix']['agent']['source_url'] = "http://domain.com/path/to/source.tar.gz"
```

#### Prebuild install

The current latest prebuild is behind the source and packaged versions.  You will need to set

```ruby
node['zabbix']['agent']['version']
```

to the version you wish to be installed.

#### Cookbook file install

This will install a provided package that can be included in the ./files directory of the cookbook itself and stored on the chef server.

#### Chocolatey install

Currently untested.  Pull requests and kitchen tests desired.

### Note

A Zabbix agent running on the Zabbix server will need to :

- use a different account than the one the server uses or it will be able to spy on private data.
- specify the local Zabbix server using the localhost (127.0.0.1, ::1) address.

## Recipies

### default

The default recipe installs, configures and starts the zabbix_agentd.

You can control the agent install with the following attributes:

```ruby
    node['zabbix']['agent']['install_method'] = 'package' # Default
```

or

```ruby
    node['zabbix']['agent']['install_method'] = 'source'
```

or

```ruby
    node['zabbix']['agent']['install_method'] = 'prebuild'
```

or

```ruby
    node['zabbix']['agent']['install_method'] = 'cookbook_file' # not yet implemented
```

### service

Controls the service start/stop/restart

### configure

applies the provided attributes to the configurable items

### install

Installs the cookbook based on the 'install_method'.  Includes one of the following recipes

#### install\_source

Downloads and installs the Zabbix agent from source

#### install\_package

Sets up the Zabbix default repository and installs the agent from there

#### install\_prebuild

Downloads the Zabbix prebuilt tar.gz file and installs it

#### install\_chocolatey

Needs testing

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
