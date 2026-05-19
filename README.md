# Chef Cookbook - zabbix-agent

[![Cookbook Version](https://img.shields.io/cookbook/v/zabbix-agent.svg)](https://supermarket.chef.io/cookbooks/zabbix-agent)
[![CI State](https://github.com/sous-chefs/zabbix-agent/workflows/ci/badge.svg)](https://github.com/sous-chefs/zabbix-agent/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

This cookbook provides custom resources for installing, configuring, and managing Zabbix Agent.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook
maintainers working together to maintain important cookbooks. If you would like to know more please
visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in
[#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

* AlmaLinux 8+
* Amazon Linux 2023+
* CentOS Stream 9+
* Debian 12+
* Oracle Linux 8+
* Red Hat Enterprise Linux 8+
* Rocky Linux 8+
* Ubuntu 22.04+

See [LIMITATIONS.md](LIMITATIONS.md) for package and source-install details.

### Chef

Chef Infra Client 15.3 or later.

## Migration

This release removes the legacy recipe and node attribute API. See [migration.md](migration.md) for
mapping examples.

## Resources

* [zabbix_agent](documentation/zabbix-agent_zabbix_agent.md)
* [zabbix_agent_registration](documentation/zabbix-agent_zabbix_agent_registration.md)

## Usage

```ruby
zabbix_agent 'default' do
  config(
    'Server' => 'zabbix.example.com',
    'ServerActive' => 'zabbix.example.com'
  )
  action %i(create start)
end
```

### Source Install

```ruby
zabbix_agent 'source' do
  install_method 'source'
  version '7.0.26'
  configure_options ['--with-libcurl', '--with-libpcre2']
  action %i(create start)
end
```

### Prebuilt Static Install

```ruby
zabbix_agent 'prebuild' do
  install_method 'prebuild'
  version '7.0.26'
  prebuild_arch 'amd64'
  action %i(create start)
end
```

## Contributors

This project exists thanks to all the people who
[contribute](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false).

### Backers

Thank you to all our backers.

![OpenCollective backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![Sponsor 0](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![Sponsor 1](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![Sponsor 2](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![Sponsor 3](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![Sponsor 4](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![Sponsor 5](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![Sponsor 6](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![Sponsor 7](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![Sponsor 8](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![Sponsor 9](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
