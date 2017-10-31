class profile::common::packages {

  notice "class profile::common::packages"

  $install = [ 'binutils.x86_64', 'unzip.x86_64' ]

  package { $install :
    ensure  => present,
  }
  
}
