class profiles::consul {
  dnsmasq::conf { 'consul':
    ensure  => present,
    content => 'server=/consul/127.0.0.1#8600',
  }

  exec { 'consul join first':
    path      => ['/bin/', '/usr/local/bin/'],
    unless    => 'hostname | grep first',
    tries     => 10,
    try_sleep => 1,
  }

  ::consul::service { 'puppet':
    port    => 8139,
  }

}
