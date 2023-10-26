# CHANGELOG

## Unreleased

## 0.15.7 - *2023-10-26*

- Fix notification triggers

## 0.15.6 - *2023-09-28*

- resolved cookstyle error: .delivery/project.toml:2:8 convention: `Style/StringLiterals`
- resolved cookstyle error: .delivery/project.toml:4:10 convention: `Style/StringLiterals`
- resolved cookstyle error: .delivery/project.toml:5:13 convention: `Style/StringLiterals`
- resolved cookstyle error: .delivery/project.toml:6:10 convention: `Style/StringLiterals`
- resolved cookstyle error: .delivery/project.toml:7:9 convention: `Style/StringLiterals`
- resolved cookstyle error: .delivery/project.toml:8:14 convention: `Style/StringLiterals`
- resolved cookstyle error: .delivery/project.toml:9:11 convention: `Style/StringLiterals`

## 0.15.5 - *2023-09-28*

- Standardise files with files in sous-chefs/repo-management

## 0.15.4 - *2023-02-14*

## 0.15.3 - *2021-08-31*

- Standardise files with files in sous-chefs/repo-management

## 0.15.2 - *2021-06-01*

- resolved cookstyle error: spec/default_spec.rb:131:25 warning: `ChefDeprecations/DeprecatedChefSpecPlatform`

## 0.15.1 (2020-05-05)

- resolved cookstyle error: recipes/configure.rb:34:3 refactor: `ChefStyle/NegatingOnlyIf`

## 0.15.0 (2020-20-01)

- Require Chef Infra Client 14 or later
- Upgrade the default client version to 3.0.29 as 3.0.9 isn't on the Zabbix site anymore
- Fix prebuilt installs since the packages on the Zabbix site have changed name format
- Use the Linux 3.x prebuilt binaries not 2.6 binaries
- Use systemd not sys-v init scripts to start the agent on Debian / RHEL based systems now
- Use the build_essential resource and remove the dependency on the build-essential cookbook
- Removed the apt-get update before adding the Zabbix apt repository as this is not necessary
- Removed the include_recipe 'yum' before setting up the Zabbix yum repo as this is not necessary
- Removed dependency on apt and yum cookbooks
- Change Test Kitchen testing to kitchen-dokken
- Remove ChefSpec matchers file which is no longer necessary with ChefSpec 7.1
- Use multi-package installs where available to speed up package installation
- Use platform? and platform_family? helpers where possible to simplify the codebase
- Simplify the apt_repository usage by removing `distribution` property
- Fix source installs on Debian 10+ and Ubuntu 18.04+
- Migrate to Github actions for testing
- Use platform_family not platform to better support derivative OS releases like Oracle Linux

## 0.14.0

- upgrade to default client version 3.0.9
- move kitchen to docker so it can be run in travisci

## 0.12.0

- include kitchen tests for all supported OS types
- upgrade to default client version 2.4.4
- cleanup source compile dependancies
- added debian as supported
- added more distributions and versions to kitchen testing
- many bug fixes for diffrent distribution versions

## 0.11.0

- Move LWRPs to their own cookbook to clean up zabbix-agent
- Clean up linting and unit tests

## 0.10.0

- Upgrading from 0.9.0 may require some slight changes to attribute names that control the configuration file.
- Migrate zabbix_agentd.conf to a fully dynamically generated template
- Include many more tests
- General clean-up of code

## 0.9.0

- Major refactor of all code.
- Rename cookbook to zabbix-agent, strip out all server, web, java-gateway dependencies.
- Add default code path chefspec tests
- Update kitchen tests
- Added package install from repo.zabbix.com
- Rename many cookbooks to follow a Install->Configure->Service design pattern.
