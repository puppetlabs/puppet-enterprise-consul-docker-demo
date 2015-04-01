# andschwa-unattended_upgrades

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup - The basics of getting started with andschwa-unattended_upgrades](#setup)
    * [What andschwa-unattended_upgrades affects](#what-andschwa-unattended_upgrades-affects)
    * [Beginning with andschwa-unattended_upgrades](#beginning-with-andschwa-unattended_upgrades)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module installs the 'unattended-upgrades' package, installs the
configuration files using templates, and ensures the service is
running.

Note that this module is a bit superfluous if you're using
[puppetlabs/apt](https://github.com/puppetlabs/puppetlabs-apt), as it
can fully configure unattended upgrades. I realized this only after I
wrote this package, and personally switched to it in the interest of
simplicity. However, as this does not require the apt module as a
dependency, it may still be useful to some.

## Module Description

This module is intended for Ubuntu and Debian systems, where the
'unattended-upgrades' package is available. Alternatives include
scheduling updates with cron by hand (and in fact,
'unattended-upgrades' utilizes cron), and using cron-apt (more detail
[here](https://help.ubuntu.com/community/AutomaticSecurityUpdates)).

## Setup

### What andschwa-unattended_upgrades affects

* Packages
    * `unattended-upgrades`
* Services
    * `unattended-upgrades`
* Files
    * `/etc/apt/apt.conf.d/20auto-upgrades`
    * `/etc/apt/apt.conf.d/50unattended-upgrades`

### Beginning with andschwa-unattended_upgrades

The simplest use of this module is:

    include unattended_upgrades

### Usage

This module has one class, `unattended_upgrades`, with the following
parameters:

    $period        = 1,              # Update period (in days)
    $repos         = {},             # Repos to upgrade - defaults to empty.
    $blacklist     = [],             # Packages to not update
    $email         = '',             # Email for update status
    $autofix       = true,           # Ensure updates keep getting installed
    $minimal_steps = true,           # Allows for shutdown during an upgrade
    $on_shutdown   = false,          # Install only on shutdown
    $on_error      = false,          # Email only on errors, else always
    $autoremove    = false,          # Automatically remove unused dependencies
    $auto_reboot   = false,          # Automatically reboot if needed

Logs are at the usual `/var/log/unattended-upgrades`, and emails will
be automatically sent if an email is given.

The `$minimal_steps` option will split the upgrade into the smallest
possible chunks, which allows them to be safely interruped (with
SIGUSR1). There is a small performance penalty, but it lets you
shutdown the machine while an upgrade is in progess.

The `$autofix` option determines if unattended-upgrades will, upon
an unclean dpkg exit, automatically run `dpkg --force-confold
--configure -a`. It defaults to true so that updates will continue
being automatically installed.

The `$autoremove` option will clean unused dependencies, further
configuration is available via the periodic configurations in
`/etc/apt/apt.conf.d/`.

## Sample 

    # Unattended upgrades
    $upgrade_blacklist = hiera_array('do_not_upgrade')
    class {'::unattended_upgrades':
      period    => '1',
      repos     => {
        stable => {
          label => 'Debian-Security',
        },
      },
      blacklist => $upgrade_blacklist,
      email     => 'ops@company.com',
    }

## do_not_upgrade hash

You can define the do_not_upgrade hash in your module or in Hiera. Hiera is a more sensible location for this sort of thing. 

    {
      "do_not_upgrade": [
        "nginx(.*)",
        "apache2(.*)",
        "postgresql(.*)",
        "mysql(.*)",
        "redis-server",
        "haproxy",
        "elasticsearch"
      ]
    }

## Limitations

This module only works on systems using apt package management: Ubuntu
and Debian (and their derivatives).

## Development

Fork on
[GitHub](https://github.com/andschwa/puppet-unattended_upgrades), make
a Pull Request.
