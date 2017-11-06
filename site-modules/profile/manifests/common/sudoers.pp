class profile::common::sudoers {

  notice "class profile::common::sudoers"

  include sudo
  include sudo::configs

  sudo::conf { 'default' :
    source      => "puppet:///modules/profile/sudoers.dat",
    priority    => 0,
    require     => Class['sudo'],
  }

  Class['sudo'] -> Class['sudo::configs']
  
}
