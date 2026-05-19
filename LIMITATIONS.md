# Limitations

## Package Availability

The default package workflow uses the official Zabbix 7.0 LTS repositories.

### APT (Debian/Ubuntu)

Official Zabbix 7.0 APT repository directories are published for:

* Debian 12 (bookworm)
* Debian 13 (trixie)
* Ubuntu 22.04 (jammy)
* Ubuntu 24.04 (noble)

The repository also still exposes older Debian and Ubuntu releases, but this cookbook only tests
current non-EOL suites. Local arm64 Dokken verification did not find an Ubuntu 24.04
`zabbix-agent` package candidate, so the default local Kitchen suite verifies the source build and
configuration path.

### DNF/YUM (RHEL family)

Official Zabbix 7.0 RPM repository directories are published for RHEL-compatible major versions
6, 7, 8, 9, and 10. This cookbook tests the currently supported RHEL-compatible platforms:

* AlmaLinux 8 and 9
* Amazon Linux 2023
* CentOS Stream 9
* Oracle Linux 8 and 9
* Rocky Linux 8 and 9

### Windows

The legacy cookbook exposed a Chocolatey install path but documented it as untested. The migrated
custom-resource public API is verified on Linux platforms only.

## Architecture Limitations

The official package repositories publish platform-specific packages and do not provide every
architecture for every distribution. The prebuilt static agent archive defaults to Linux `amd64`;
set the `prebuild_arch` property to `i386` for the official 32-bit static archive.

## Source/Compiled Installation

The source install workflow downloads official source archives from
`https://cdn.zabbix.com/zabbix/sources/stable/`.

### Build Dependencies

| Platform Family | Packages |
| --- | --- |
| Debian | build-essential, libcurl4, libcurl4-openssl-dev, libpcre2-dev, pkg-config |
| RHEL | gcc/make toolchain, curl-devel, openssl-devel, pcre2-devel, pkgconf-pkg-config, redhat-lsb |

## Known Issues

* Package installs manage the package-supplied service with Chef's built-in `service` resource.
  The cookbook does not create or override service units.
* Source and prebuilt installs build/extract and configure the agent only. They do not create a
  system service because no service is supplied by those installation artifacts.
* The old `agent_registration` recipe depended on external libzabbix resources without declaring a
  cookbook dependency. It is available as `zabbix_agent_registration` for consumers that provide
  the required libzabbix resource in their wrapper cookbook.
