class profiles::swarm_manager {
  ::docker::run { 'swarm-manager':
    image   => 'swarm',
    ports   => '3000:2375',
    command => "manage consul://${::ipaddress_eth1}:8500/swarm_nodes",
    require => Docker::Run['swarm'],
  }
  ::consul::service { 'swarm-manager':
    port => 3000,
  }
}
