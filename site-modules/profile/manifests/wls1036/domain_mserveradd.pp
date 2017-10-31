class profile::wls1036::domain_mserveradd (
  String  $domain_name,
  String  $weblogic_user,
  String  $weblogic_password,
  String  $mserver_name,
  String  $mserver_port,
  String  $machine_name,
  
  Array[Hash] $mservers        = [{teste => 'giba'}],

  String  $source_path         = '/software',
  String  $ora_home            = '/opt/oracle',
  String  $fmw_home            = '/opt/oracle/fmw11g',
  String  $os_user             = 'oracle',
  String  $os_group            = 'oracle',
  String  $log_dir             = '/data/log',
) {

  notice "class profile::wls1036::domain_mserveradd"

  #require 'profile::wls1036::domain'
  $mservers.each | Hash $item | {
    $x = $item[teste]
    notice "MSERVER $x"
    /*
    $item.each | $key, $value | {
      notice "MSERVER $key $value"
    }
    */
  }

  #lookup('users', Hash, 'hash').each | String $username, Hash $attrs | {

  /*
  wls_machine { $machine_name :
    ensure        => 'present',
    listenaddress => 'none',
    listenport    => '5556',
    machinetype   => 'UnixMachine',
    nmtype        => 'SSL',
    require       => Wls_setting['default']
  }
  */

  wls_server { $mserver_name :
    ensure                            => 'present',
    arguments                         => "-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=$log_dir/${mserver_name}.out -Dweblogic.Stderr=$log_dir/${mserver_name}_err.out",
    listenport                        => $mserver_port,
    machine                           => 'LocalMachine',
    logfilename                       => "$log_dir/${mserver_name}.log",
    log_http_filename                 => "$log_dir/${mserver_name}_access.log",
    log_datasource_filename           => "$log_dir/${mserver_name}_datasource.log",
    log_file_min_size                 => '2000',
    log_filecount                     => '10',
    log_number_of_files_limited       => '1',
    log_rotate_logon_startup          => '1',
    log_rotationtype                  => 'bySize',
    max_message_size                  => '10000000',
    jsseenabled                       => '0',
    sslenabled                        => '0',
    #require                           => Wls_machine[$machine_name],
    require                           => Class['profile::wls1036::domain']
  }

  <-

  tidy { 'pack-remove' :
    path => "/var/tmp/install/domain_$domain_name.jar",
  }

  <-

  orawls::packdomain { 'default' :
    middleware_home_dir        => $fmw_home,
    weblogic_home_dir          => "$fmw_home/wlserver_10.3",
    wls_domains_dir            => "$fmw_home/user_projects/domains",
    jdk_home_dir               => "/usr/java/latest",
    download_dir               => "/var/tmp/install",
    domain_name                => $domain_name,
    os_user                    => $os_user,
    os_group                   => $os_group,
    log_output                 => true,
    #require                    => Wls_server[$mserver_name],
  }

  <-

  file { "/var/tmp/install/domain_$domain_name.jar" :
    ensure    => 'file',
    mode      => '774',
  }
    
}
