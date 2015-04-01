class motd::params {
  case $::osfamily {
    redhat, debian, suse, gentoo: {
      $config_file = '/etc/motd'
      $template = 'motd/motd.erb'
    }
    default: {
      case $::operatingsystem {
        gentoo: {
          $config_file = '/etc/motd'
          $template = 'motd/motd.erb'
        }
        default: {
          fail("The ${module_name} module is not supported on ${::osfamily}/${::operatingsystem}.")
        }
      }
    }
  }
}
