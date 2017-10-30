class profile::wls1036_os (
  Boolean $swap        = false,
  String  $user        = 'oracle',
  String  $password    = '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
  String  $group       = 'oracle',
) {

  notice "class profile::wls1036_os"

  $install = [ 'binutils.x86_64', 'unzip.x86_64' ]

  package { $install :
    ensure  => present,
  }
  
  if ($swap) {
    notice "SWAP ENABLED"
    swap_file::files { 'default':
      ensure => present,
    }
  }
  
  service { 'iptables':
    ensure    => stopped,
    enable    => false,
  }

  exec { 'clear-iptables':
    command => "/sbin/iptables -F",
    onlyif  => "/sbin/lsmod | grep ip_tables",
  }

  group { $group :
    ensure => present,
  }

  # http://raftaman.net/?p=1311 for generating password (password = oracle)
  user { $user :
    ensure     => present,
    groups     => $group,
    shell      => '/bin/bash',
    password   => $password,
    home       => "/home/$user",
    comment    => 'User created by Puppet',
    managehome => true,
    require    => Group[$group],
  }

  class { 'limits':
    config => {
      '*'          => { 'nofile'  => { soft => '2048'   , hard => '32768', },},
      $user        => { 'nofile'  => { soft => '65536'  , hard => '32768', },
                        'nproc'   => { soft => '2048'   , hard => '32768', },
                        'memlock' => { soft => '1048576', hard => '1048576', },
                        'stack'   => { soft => '10240'  ,},},
    },
    use_hiera => false,
  }

  sysctl { 'kernel.msgmnb':                 ensure => 'present', permanent => 'yes', value => '65536',}
  sysctl { 'kernel.msgmax':                 ensure => 'present', permanent => 'yes', value => '65536',}
  sysctl { 'kernel.shmmax':                 ensure => 'present', permanent => 'yes', value => '2588483584',}
  sysctl { 'kernel.shmall':                 ensure => 'present', permanent => 'yes', value => '2097152',}
  sysctl { 'fs.file-max':                   ensure => 'present', permanent => 'yes', value => '6815744',}
  sysctl { 'net.ipv4.tcp_keepalive_time':   ensure => 'present', permanent => 'yes', value => '1800',}
  sysctl { 'net.ipv4.tcp_keepalive_intvl':  ensure => 'present', permanent => 'yes', value => '30',}
  sysctl { 'net.ipv4.tcp_keepalive_probes': ensure => 'present', permanent => 'yes', value => '5',}
  sysctl { 'net.ipv4.tcp_fin_timeout':      ensure => 'present', permanent => 'yes', value => '30',}
  sysctl { 'kernel.shmmni':                 ensure => 'present', permanent => 'yes', value => '4096', }
  sysctl { 'fs.aio-max-nr':                 ensure => 'present', permanent => 'yes', value => '1048576',}
  sysctl { 'kernel.sem':                    ensure => 'present', permanent => 'yes', value => '250 32000 100 128',}
  sysctl { 'net.ipv4.ip_local_port_range':  ensure => 'present', permanent => 'yes', value => '9000 65500',}
  sysctl { 'net.core.rmem_default':         ensure => 'present', permanent => 'yes', value => '262144',}
  sysctl { 'net.core.rmem_max':             ensure => 'present', permanent => 'yes', value => '4194304', }
  sysctl { 'net.core.wmem_default':         ensure => 'present', permanent => 'yes', value => '262144',}
  sysctl { 'net.core.wmem_max':             ensure => 'present', permanent => 'yes', value => '1048576',}

}
