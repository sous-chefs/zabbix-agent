# TODO
* Verify and test on freebsd
* Add cookbook_file install method

# CHANGELOG
### 0.14.0
  * upgrade to default client version 3.0.9
  * move kitchen to docker so it can be run in travisci

### 0.13.0
### 0.12.0
  * include kitchen tests for all supported OS types
  * upgrade to default client version 2.4.4
  * cleanup source compile dependancies
  * added debian as supported
  * added more distributions and versions to kitchen testing
  * many bug fixes for diffrent distribution versions

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
