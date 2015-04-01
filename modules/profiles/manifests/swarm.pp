class profiles::swarm {
  ::docker::image { 'swarm': }

  ::docker::run { 'swarm':
    image   => 'swarm',
    command => "join --addr=${::ipaddress_eth1}:2375 consul://${::ipaddress_eth1}:8500/swarm_nodes"
  }

  ::consul::service { 'swarm':
    port => 2375,
  }
}
