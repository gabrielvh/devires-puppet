class profile::common::users {

  notice "class profile::common::users"

  group { 'guest' :
    ensure => present,
  }

  user { 'guest' :
    ensure     => present,
    groups     => 'guest',
    shell      => '/bin/bash',
    password   => '!!',
    home       => "/home/guest",
    comment    => 'User created by Puppet',
    managehome => true,
    require    => Group['guest'],
  }

  file { "/home/guest/.ssh/" :
    owner  => "guest",
    group  => "guest",
    mode   => "700",
    ensure => "directory",
    require => User['guest'],
  }

  file { "/home/guest/.ssh/id_rsa" :
    ensure  => present,
    owner   => "guest",
    group   => "guest",
    mode    => "600",
    source  => "puppet:///modules/profile/ssh/guest/id_rsa",
    require => User['guest'],
  }

  file { "/home/guest/.ssh/id_rsa.pub" :
    ensure  => present,
    owner   => "guest",
    group   => "guest",
    mode    => "644",
    source  => "puppet:///modules/profile/ssh/guest/id_rsa.pub",
    require => User['guest'],
  }

  file { "/home/guest/.ssh/authorized_keys" :
    ensure  => present,
    owner   => "guest",
    group   => "guest",
    mode    => "644",
    source  => "puppet:///modules/profile/ssh/guest/id_rsa.pub",
    require => User['guest'],
  }
  
}
