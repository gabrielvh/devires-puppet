class role::ora12c_server (
  Hash    $machines             = {},
  Hash    $managed_servers      = {},
  Boolean $install_rcu          = true,
) {

  include profile::common
  include profile::java7
  include profile::ora12c::system
  include profile::ora12c::rcu

  class { 'profile::ora12c::server' :
    machines                => $machines,
    managed_servers         => $managed_servers,
  }

  if($install_rcu){
    Class['profile::common']
      -> Class['profile::java7']
        -> Class['profile::ora12c::system']
          -> Class['profile::ora12c::server']
            -> Class['profile::ora12c::rcu']
  }else{
    Class['profile::common']
      -> Class['profile::java7']
        -> Class['profile::ora12c::system']
          -> Class['profile::ora12c::server']
  }

}
