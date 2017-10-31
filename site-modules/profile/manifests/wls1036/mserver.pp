class profile::wls1036::mserver (
  String  $domain_name,
  String  $weblogic_user,
  String  $weblogic_password,
  String  $mserver_name,
  String  $mserver_port,
  String  $machine_name,
  String  $adminserver_address,
  String  $ora_home            = '/opt/oracle',
  String  $fmw_home            = '/opt/oracle/fmw11g',
  String  $source_path         = "/software",
  String  $os_user             = 'oracle',
  String  $os_group            = 'oracle',
  String  $log_dir             = '/data/log',
) {

  notice "class profile::wls1036::mserver"

  class { 'orawls::weblogic' :
    version                    => 1036,
    filename                   => "wls1036_generic.jar",
    source                     => $source_path,
    oracle_base_home_dir       => $ora_home,
    middleware_home_dir        => $fmw_home,
    weblogic_home_dir          => "$fmw_home/wlserver_10.3",
    wls_domains_dir            => "$fmw_home/user_projects/domains",
    wls_apps_dir               => "$fmw_home/user_projects/applications",
    fmw_infra                  => false,
    jdk_home_dir               => "/usr/java/latest",
    os_user                    => $os_user,
    os_group                   => $os_group,
    download_dir               => "/var/tmp/install",
    temp_directory             => "/var/tmp/install",
    remote_file                => false,
    log_output                 => true,
    java_parameters            => '', # '-Dspace.detection=false'
    require                    => Class['profile::wls1036::system']
  }

  exec { 'copydomain' :
    command   => "scp -oStrictHostKeyChecking=no -oCheckHostIP=no guest@$adminserver_address:/var/tmp/install/domain_${domain_name}.jar /var/tmp/domain_${domain_name}.jar",
    path      => "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin",
    user      => "guest",
    group     => "guest",
    logoutput => true,
    require   => Class['orawls::weblogic']
  }

  file { "/var/tmp/domain_${domain_name}.jar" :
    ensure  => present,
    mode    => "777",
    alias   => "domain-pack-file",
    require => Exec['copydomain'],
  }

  orawls::copydomain { 'default' :
    version                    => 1036,
    weblogic_home_dir          => "$fmw_home/wlserver_10.3",
    middleware_home_dir        => $fmw_home,
    jdk_home_dir               => "/usr/java/latest",
    wls_domains_dir            => "$fmw_home/user_projects/domains",
    wls_apps_dir               => "$fmw_home/user_projects/applications",
    download_dir               => "/var/tmp/install",
    use_ssh                    => false,
    domain_pack_dir            => "/var/tmp",
    os_user                    => $os_user,
    os_group                   => $os_group,
    log_dir                    => $log_dir,
    log_output                 => true,
    domain_name                => $domain_name,
    weblogic_user              => $weblogic_user,
    weblogic_password          => $weblogic_password,
    adminserver_address        => $adminserver_address,
    adminserver_port           => '7001',
    require                    => File['domain-pack-file']
  }

  orawls::storeuserconfig { 'default' :
    weblogic_home_dir          => "$fmw_home/wlserver_10.3",
    jdk_home_dir               => "/usr/java/latest",
    download_dir               => "/var/tmp/install",
    domain_name                => $domain_name,
    os_user                    => $os_user,
    os_group                   => $os_group,
    log_output                 => true,
    adminserver_address        => $adminserver_address,
    adminserver_port           => 7001,
    user_config_dir            => "/home/$os_user",
    weblogic_user              => $weblogic_user,
    weblogic_password          => $weblogic_password,
    require                    => Orawls::Copydomain['default'],
  }

  orawls::nodemanager { 'nodemanager' :
    version                    => 1036,
    middleware_home_dir        => $fmw_home,
    weblogic_home_dir          => "$fmw_home/wlserver_10.3",
    wls_domains_dir            => "$fmw_home/user_projects/domains",
    jdk_home_dir               => "/usr/java/latest",
    download_dir               => "/var/tmp/install",
    domain_name                => $domain_name,
    os_user                    => $os_user,
    os_group                   => $os_group,
    log_dir                    => $log_dir,
    log_output                 => true,
    nodemanager_port           => 5556,
    nodemanager_address        => undef,
    require                    => Orawls::Storeuserconfig['default'],
  }

  wls_setting { 'default' :
    user                         => $os_user,
    weblogic_home_dir            => "$fmw_home/wlserver_10.3",
    connect_url                  => "t3://$adminserver_address:7001",
    weblogic_user                => $weblogic_user,
    weblogic_password            => $weblogic_password,
    require                      => Orawls::Copydomain['default'],
  }

  wls_machine { $machine_name :
    ensure        => 'present',
    listenaddress => $hostname,
    listenport    => '5556',
    machinetype   => 'UnixMachine',
    nmtype        => 'SSL',
    require       => Wls_setting['default'],
  }

  wls_server { $mserver_name :
    ensure                            => 'present',
    machine                           => $machine_name,
    require                           => Wls_machine[$machine_name],
  }
    
}
