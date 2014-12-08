<table>
  <tr>
    <th>Chef Supermarket</th>
    <th>Travis-CI Build</th>
    <th>Open Chat</th>
  </tr>
  <tr>
    <td>
[![CK Version](http://img.shields.io/cookbook/v/nodejs.svg)](https://supermarket.getchef.com/cookbooks/zabbix-agent)</td>
    <td>
[![Build Status](https://secure.travis-ci.org/TD-4242/zabbix-agent.png)](http://travis-ci.org/TD-4242/zabbix-agent)</td>
    <td>
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/TD-4242/zabbix-agent?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)</td>
  </tr>
</table>
# Chef Cookbook - zabbix-agent
This cookbook installs and configures the zabbix-agent.  It is a refactoring of the zabbix cookbook from https://github.com/laradji/zabbix that strips out the server install dependancies and focuses only on installing the agent.

## USAGE
Update the metadata.rb and change your package type (apt, yum) from "recommends" to "depends."

If you have internet access and a searchable dns alias so "zabbix" will resolve to your zabbix server this cookbook may work with no aditional changes.  Just include recipe[zabbix-agent] in your runlist. 

Otherwise you will need to modify:

    node['zabbix']['agent']['servers']

and

    default['zabbix']['agent']['package']['repo_uri']
    default['zabbix']['agent']['package']['repo_key']

or try one of the other install methods

### Default Install, Configure and run zabbix agent
Install packages from repo.zabbix.com and run the Agent:

```json
{
  "run_list": [
    "recipe[zabbix]"
  ]
}
```

### Selective Install or Install and Configure (don't start zabbix-agent)
Alternativly you can just install, or install and configure:

```json
{
  "run_list": [
    "recipe[zabbix::install]"
  ]
}
```
  or
```json
{
  "run_list": [
    "recipe[zabbix::configure]"
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
If you do not set any attributes you will get an install of zabbix agent version 2.2.7 with
what should be a working configuration if your DNS has aliases for zabbix.yourdomain.com and
your hosts search yourdomain.com.

#### Source install
If you do not specify source\_url attributes for agent it will be set to download the specified branch and version from the official Zabbix source repository. If you want to upgrade later, you need to either nil out the source\_url attributes or set them to the url you wish to download from.

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
Installs the cookbook based on the 'install_method'.  Includse one of the following recipies

#### install\_source
Downloads and installs the Zabbix agent from source

If you are on a machine in the RHEL family of platforms, then you will need to install packages from the EPEL repository. The easiest way to do this is to add the following recipe to your runlist before zabbix::agent\_source

    recipe "yum::epel"

You can control the agent install with:

#### install\_package
Sets up the Zabbix default repository and installs the agent from there

#### install\_prebuild
Needs testing

#### install\_chocolatey
Needs testing

# LWRPs
Currently the LWRPs have not been completely ported to the new zabbix-agent cookbook.

zabbix-agent\_api\_call
zabbix-agent\_application
zabbix-agent\_discovery\_rule
zabbix-agent\_graph
zabbix-agent\_host\_group
zabbix-agent\_hostgroup
zabbix-agent\_host
zabbix-agent\_interface
zabbix-agent\_item
zabbix-agent\_source
zabbix-agent\_template
zabbix-agent\_trigger\_dependency
zabbix-agent\_trigger
zabbix-agent\_user


# TODO

* Support more platform on agent side windows ?
* LWRP cleanup, port and testing
* Update documentation

# CHANGELOG
### 0.9.0
  * Major refactor of all code.  
  * Rename cookbook to zabbix-agent, strip out all server, web, java-gateway dependancies.
  * Add default code path chefspec tests
  * Update kitchen tests
  * Added package install from repo.zabbix.com
  * Rename many cookbooks to follow a Install->Configure->Service design pattern.

### 0.8.0
  * This version is a big change with a lot of bugfix and change. Please be carefull if you are updated from previous version

### 0.0.42
  * Adds Berkshelf/Vagrant 1.1 compatibility (andrewGarson)
  * Moves recipe[yum::epel] to a documented runlist dependency instead of forcing you to use it via include_recipe

### 0.0.41
  * Format metadata and add support for Oracle linux (Thanks to tas50 and his love for oracle Linux)
  * Fix about redhat LSB in agent-prebuild recipe (Thanks nutznboltz)
  * Fix Add missing shabang for init file. (Thanks justinabrahms)
  * Fix FC045 foodcritic
  * new dependencies version on database and mysql cookbook
  * Add support for custom config file location to zabbix-agent.init-rh.erb (Thanks charlesjohnson)

### 0.0.40
  * Refactoring for passing foodcritic with help from dkarpenko
  * Added new attribute for server service : log_level
  * Added new attribute for server service : max_housekeeper_delete & housekeeping_frequency
  * Modified firewall recipe to accept connection to localhost zabbix_server

### 0.0.39
  * Added zabbix bin patch in init script (deprecate change made in 0.0.38)
  * Changed default zabbix version to 2.0.3

### 0.0.38
  * Added zabbix_agent bin dir into PATH for Debian/Ubuntu (Some script need zabbix_sender)

### 0.0.37
  * Having run dir in /tmp is not so good (Guilhem Lettron)

### 0.0.36
  * added restart option to zabbix-agent service definitions (Paul Rossman Patch)

### 0.0.35
  * Fix from Amiando about server_alias how should be a Array.
  * Fix from Guilhem about default run_dir be /tmp,it can be a big problem.

### 0.0.34
  * remove the protocol filter on firewall.

### 0.0.33
* Added ServerActive configuration option for Zabbix agents (Paul Rossman Patch)

### 0.0.32
  * Fix a issue about order in the declaration of service and the template for recipes agent_*

### 0.0.31
  * Readme typo

### 0.0.30
  * Thanks to Paul Rossman for this release
  * Zabbix default install version is now 2.0.0
  * Option to install Zabbix database on RDS node (default remains localhost MySQL)
  * MySQL client now installed with Zabbix server
  * Added missing node['zabbix']['server']['dbport'] to templates/default/zabbix_web.conf.php.erb
  * Fixed recipe name typo in recipes/web.rb

### 0.0.29
  * Thanks to Steffen Gebert for this release
  * WARNING! this can break stuff : typo error on attribute file default['zabbix']['agent']['server'] -> default['zabbix']['agent']['servers']
  * Evaluate node.zabbix.agent.install as boolean, not as string
  * Respect src_dir in mysql_setup

### 0.0.28
  * Thanks to Steffen Gebert for this release
  * Use generic sourceforge download URLs
  * Fix warning string literal in condition
  * Deploy zabbix.conf.php file for web frontend
  * Add "status" option to zabbix_server init script
  * Make MySQL populate scripts compatible with zabbix 2.0
  * Add example for Chef Solo usage to Vagrantfile

### 0.0.27
  * Configuration error about include_dir in zabbix_agentd.conf.erb

###	0.0.26
  * zabbix agent and zabbix server don't want the same include_dir, be carefull if you use include_dir
  * noob error on zabbix::server

### 0.0.25
  * Don't try to use String as Interger !

### 0.0.24
  * Markdown Format for Readme.md

### 0.0.23
  * Some Foodcritic

### 0.0.22
  * Bug in metadata dependencies
  * Firewall does not fix the protocol anymore

### 0.0.21
  * Added Patch from Harlan Barnes <hbarnes@pobox.com> his patch include centos/redhat zabbix_server support.
  * Added Patch from Harlan Barnes <hbarnes@pobox.com> his patch include directory has attribute.
  * Force a minimum version for apache2 cookbook


### 0.0.20
  * Added Patch from Harlan Barnes <hbarnes@pobox.com> his patch include centos/redhat zabbix_agent support.

### 0.0.19
  * Fix README

### 0.0.18
  * Fix sysconfdir to point to /etc/zabbix on recipe server_source
  * Fix right for folder frontends/php on recipe web
  * Hardcode the PATH of conf file in initscript
  * Agent source need to build on a other folder
  * Add --prefix option to default attributes when using *-source recipe

### 0.0.17
  * Don't mess with te PID, PID are now in /tmp

### 0.0.16
  * Add depencies for recipe agent_source
  * Add AlertScriptsPath folder and option for server.

### 0.0.15
  * Add firewall magic for communication between client and server

### 0.0.14
  * Correction on documentation

### 0.0.13
  * Fix some issue on web receipe.

### 0.0.12
  * Change default value of zabbix.server.dbpassword to nil

### 0.0.11
  * Remove mikoomo
  * Still refactoring

### 0.0.10
  * Preparation for multiple type installation and some refactoring
  * Support the installation of a beta version when using the install_method == source and changing the attribute branch

### 0.0.9
  * Tune of mikoomi for running on agent side.

### 0.0.8
  * Fix some major issu

### 0.0.7
  * Add some love to php value
  * Now recipe mysql_setup populate the database
  * Minor fix

### 0.0.6
  * Change the name of the web_app to fit the fqdn
