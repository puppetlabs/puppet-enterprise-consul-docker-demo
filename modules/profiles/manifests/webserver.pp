class profiles::webserver {
  include ::nginx

  file { '/usr/bin/runpuppet.sh':
    ensure  => present,
    mode    => '0777',
    content => "#!\nsudo puppet agent --onetime --no-splay --ignorecache --no-daemonize --no-usecacheonfailure",
  }

  file { '/var/www':
    ensure => directory,
    owner  => 'nginx',
  }

  file { '/var/www/nginx_header.html':
    ensure => present,
    source => 'puppet:///modules/profiles/nginx_header.html',
    owner  => 'nginx',
  }

  file { '/var/www/nginx_footer.html':
    ensure => present,
    source => 'puppet:///modules/profiles/nginx_footer.html',
    owner  => 'nginx',
  }

  ::consul::watch { 'detect_backend_changes':
    type        => 'service',
    handler     => '/usr/bin/runpuppet.sh',
    service     => 'application',
    passingonly => true,
    require     => File['/usr/bin/runpuppet.sh'],
  }

  sudo::conf { 'consul':
    priority => 31,
    content  => 'consul ALL=(ALL) NOPASSWD:ALL',
  }

  $nginx_array = hiera('application', [])

  unless empty($nginx_array) {
    $members = consul_to_nginx($nginx_array)
    ::nginx::resource::upstream { 'app':
      members => $members,
    }
    ::nginx::resource::vhost { 'default':
      www_root   => '/var/www',
      try_files  => [
        '/$uri',
        '@app',
      ],
      raw_append => [
        'add_before_body /nginx_header.html;',
        'add_after_body /nginx_footer.html;',
      ],
    }
    ::nginx::resource::location { '@app':
      vhost => 'default',
      proxy => 'http://app',
    }

    ::consul::service { 'nginx':
      port => 80,
    }
  }

}
