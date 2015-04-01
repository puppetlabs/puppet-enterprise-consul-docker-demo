class roles::master {
  include profiles::base
  include profiles::consul
  include profiles::webserver
  include profiles::swarm
  include profiles::swarm_manager
}
