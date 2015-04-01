define application(
  $port,
) {
  ::docker::run { $title:
    image   => 'nginx',
    ports   => ["${port}:80"],
    volumes => "/var/www/${title}:/usr/share/nginx/html:ro",
  }

  file { "/var/www/${title}":
    ensure => directory,
  }

  file { "/var/www/${title}/index.html":
    ensure  => present,
    content => "${title} running on ${::hostname}",
  }

  ::consul::service { "application-${title}":
    service_name => 'application',
    port         => $port,
  }
}

class profiles::application {
  ::docker::image { 'nginx': }

  ::application { 'sample1': port => 8081 }
  ::application { 'sample2': port => 8082 }
  ::application { 'sample3': port => 8083 }
  ::application { 'sample4': port => 8084 }

  file { '/var/www':
    ensure => directory,
  }

}
