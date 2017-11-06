class profile::ora12c::system (
  Boolean $swap        = fasle,
  String  $user        = 'oracle',
  # String  $group       = 'oracle',
  # http://raftaman.net/?p=1311 for generating password (password = oracle)
  String  $password    = '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
  $groups = ['oinstall','dba' ,'oper']
) {

  notice "class profile::ora12c::system"

  if ($swap) {
    notice "SWAP -> $swap"
    swap_file::files { 'default':
      ensure => present,
    }
  }

  service { 'iptables' :
    ensure    => stopped,
    enable    => false,
  }

  service { 'firewalld' :
    ensure    => stopped,
    enable    => false,
  }

  group { $groups :
    ensure => present,
  }

  user { $user :
    ensure     => present,
    uid         => 500,
    gid         => 'oinstall',
    groups     => $groups,
    shell      => '/bin/bash',
    password   => $password,
    home       => "/home/$user",
    comment    => 'User created by Puppet',
    managehome => true,
    require    => Group[$groups],
  }

  $install = ['compat-libstdc++-33.x86_64',
              'glibc.x86_64',
              'ksh.x86_64',
              'libaio.x86_64',
              'libgcc.x86_64',
              'libstdc++.x86_64',
              'make.x86_64',
              'compat-libcap1.x86_64',
              'gcc.x86_64',
              'gcc-c++.x86_64',
              'glibc-devel.x86_64',
              'libaio-devel.x86_64',
              'libstdc++-devel.x86_64',
              'sysstat.x86_64',
              'unixODBC-devel',
              'glibc.i686',
              'libXext.x86_64',
              'libXtst.x86_64']
  package { $install:
    ensure  => present,
  }

  class { 'limits' :
    config => {
      '*'          => { 'nofile'  => { soft => '2048'   , hard => '32768', },},
      $user        => { 'nofile'  => { soft => '65536'  , hard => '32768', },
                        'nproc'   => { soft => '2048'   , hard => '32768', },
                        'memlock' => { soft => '1048576', hard => '1048576', },
                        'stack'   => { soft => '10240'  ,},},
    },
    use_hiera => false,
    require   => User[$user],
  }
  contain 'limits'

  sysctl { 'kernel.msgmnb' :                 ensure => 'present', permanent => 'yes', value => '65536',}
  sysctl { 'kernel.msgmax' :                 ensure => 'present', permanent => 'yes', value => '65536',}
  sysctl { 'kernel.shmmax' :                 ensure => 'present', permanent => 'yes', value => '2588483584',}
  sysctl { 'kernel.shmall' :                 ensure => 'present', permanent => 'yes', value => '2097152',}
  sysctl { 'fs.file-max' :                   ensure => 'present', permanent => 'yes', value => '6815744',}
  sysctl { 'net.ipv4.tcp_keepalive_time' :   ensure => 'present', permanent => 'yes', value => '1800',}
  sysctl { 'net.ipv4.tcp_keepalive_intvl' :  ensure => 'present', permanent => 'yes', value => '30',}
  sysctl { 'net.ipv4.tcp_keepalive_probes' : ensure => 'present', permanent => 'yes', value => '5',}
  sysctl { 'net.ipv4.tcp_fin_timeout' :      ensure => 'present', permanent => 'yes', value => '30',}
  sysctl { 'kernel.shmmni' :                 ensure => 'present', permanent => 'yes', value => '4096', }
  sysctl { 'fs.aio-max-nr' :                 ensure => 'present', permanent => 'yes', value => '1048576',}
  sysctl { 'kernel.sem' :                    ensure => 'present', permanent => 'yes', value => '250 32000 100 128',}
  sysctl { 'net.ipv4.ip_local_port_range' :  ensure => 'present', permanent => 'yes', value => '9000 65500',}
  sysctl { 'net.core.rmem_default' :         ensure => 'present', permanent => 'yes', value => '262144',}
  sysctl { 'net.core.rmem_max' :             ensure => 'present', permanent => 'yes', value => '4194304', }
  sysctl { 'net.core.wmem_default' :         ensure => 'present', permanent => 'yes', value => '262144',}
  sysctl { 'net.core.wmem_max' :             ensure => 'present', permanent => 'yes', value => '1048576',}

}
