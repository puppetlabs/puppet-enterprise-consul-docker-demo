class unattended_upgrades(
  $period        = 1,              # Update period (in days)
  $repos         = {},             # Repos to upgrade
  $blacklist     = [],             # Packages to not update
  $email         = '',             # Email for update status
  $autofix       = true,           # Ensure updates keep getting installed
  $minimal_steps = true,           # Allows for shutdown during an upgrade
  $on_shutdown   = false,          # Install only on shutdown
  $on_error      = false,          # Email only on errors, else always
  $autoremove    = false,          # Automatically remove unused dependencies
  $auto_reboot   = false,          # Automatically reboot if needed
) {

  $conf_path = '/etc/apt/apt.conf.d/50unattended-upgrades'
  $apt_path = '/etc/apt/apt.conf.d/20auto-upgrades'
  $package = 'unattended-upgrades'

  if $operatingsystem !~ /^(Debian|Ubuntu)$/ {
    fail("${operatingsystem} is not supported.")
  }

  package { $package:
    ensure => latest,
  }
  
  file { $conf_path:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('unattended_upgrades/unattended-upgrades.erb'),
  }

  file { $apt_path:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('unattended_upgrades/auto-upgrades.erb')
  }

  service { $package:
    ensure    => running,
    subscribe => [ File[$conf_path], File[$apt_path], Package[$package], ],
  }
}
