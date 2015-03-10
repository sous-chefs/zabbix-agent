# Chef Cookbook - zabbix-agent
[![CK Version](http://img.shields.io/cookbook/v/zabbix-agent.svg)](https://supermarket.getchef.com/cookbooks/zabbix-agent)
[![Build Status](https://secure.travis-ci.org/TD-4242/zabbix-agent.png)](http://travis-ci.org/TD-4242/zabbix-agent)
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/TD-4242/zabbix-agent?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This cookbook installs and configures the zabbix-agent with sane defaults and very minimal dependancies.

## Supported OS Distributions
* RHEL/CentOS 6, 7
* Ubuntu 10.04 12.04 14.04
* Debian 6.0.10 7.8
* (soon) fedora
* (soon) freebsd
* (soon) opensuse
* Would like to add Windows but need a tester or a Vagrant box to test with.

## USAGE
Update the metadata.rb and change your package type (apt, yum) from "recommends" to "depends."

If you have internet access and a searchable DNS alias so "zabbix" will resolve to your zabbix server this cookbook may work with no additional changes.  Just include recipe[zabbix-agent] in your run_list. 

Otherwise you will need to modify:

    node['zabbix']['agent']['servers']

and

    default['zabbix']['agent']['package']['repo_uri']
    default['zabbix']['agent']['package']['repo_key']

or try one of the other install methods

### zabbix_agentd.conf file
All attributes in the zabbix_agentd.conf file can be controlled from the ``node['zabbix']['agent']['conf']`` attribute.  This will require a change in attribute naming for upgrades from 0.9.0.

```
default['zabbix']['agent']['conf']['Timeout'] = '10'
```

or

```json
{
  "default_attributes": {
    "zabbix": {
      "agent": {
          "servers": ["zabbix.example.com"]
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

### ATTRIBUTES

Install Method options are:
    node['zabbix']['agent']['install_method'] = 'package' # Default

Other options are less tested:

    node['zabbix']['agent']['install_method'] = 'source'
    node['zabbix']['agent']['install_method'] = 'prebuild'
    node['zabbix']['agent']['install_method'] = 'chocolatey' # Default for Windows

Version
    node['zabbix']['agent']['version']

Don't forget to set :
    node['zabbix']['agent']['servers'] = ["Your_zabbix_server.com","secondaryserver.com"]
    node['zabbix']['agent']['servers_active'] = ["Your_zabbix_active_server.com"]

#### Package install
If you do not set any attributes you will get an install of zabbix agent version 2.4.4 with
what should be a working configuration if your DNS has aliases for zabbix.yourdomain.com and
your hosts search yourdomain.com.

#### Source install
If you do not specify source\_url attributes for agent it will be set to download the specified branch and version from the official Zabbix source repository. If you want to upgrade later, you need to either nil out the source\_url attributes or set them to the URL you wish to download from.

    node['zabbix']['agent']['version']
    node['zabbix']['agent']['configure_options']

to install an alternative branch or tar file you can specify it here

    node['zabbix']['agent']['source_url'] = "http://domain.com/path/to/source.tar.gz"

#### Prebuild install
Currently untested.  Pull requests and kitchen tests desired.

#### Chocolatey install
Currently untested.  Pull requests and kitchen tests desired.

### Note :
A Zabbix agent running on the Zabbix server will need to :
* use a different account than the on the server uses or it will be able to spy on private data.
* specify the local Zabbix server using the localhost (127.0.0.1, ::1) address.

# RECIPES

## default
The default recipe installs, configures and starts the zabbix_agentd.

You can control the agent install with the following attributes:

    node['zabbix']['agent']['install_method'] = 'source'
  or
    node['zabbix']['agent']['install_method'] = 'prebuild'
  or
    node['zabbix']['agent']['install_method'] = 'package'

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

# LWRPs
The LWRPs have been moved to the libzabbix cookbook.  https://github.com/TD-4242/cookbook-libzabbix
# TODO

* Verify and test on Windows
* Create kitchen tests

# CHANGELOG
### 0.12.0
  * include kitchen tests for all supported OS types
  * upgrade to default client version 2.4.4
  * cleanup source compile dependancies
  * added debian as supported
  * added more distributions to kitchen testing

### 0.11.0
  * Move LWRPs to their own cookbook to clean up zabbix-agent
  * Clean up linting and unit tests

### 0.10.0
  * Upgrading from 0.9.0 may require some slight changes to attribute names that control the configuration file.
  * Migrate zabbix_agentd.conf to a fully dynamically generated template
  * Include many more tests
  * General clean-up of code
  
### 0.9.0
  * Major refactor of all code.  
  * Rename cookbook to zabbix-agent, strip out all server, web, java-gateway dependencies.
  * Add default code path chefspec tests
  * Update kitchen tests
  * Added package install from repo.zabbix.com
  * Rename many cookbooks to follow a Install->Configure->Service design pattern.

### 0.8.0 forked from https://github.com/laradji/zabbix see this page for historical change log
