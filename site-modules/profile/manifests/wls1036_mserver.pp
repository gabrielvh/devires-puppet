class profile::wls1036_mserver (
  String $ora_home           = '/opt/oracle',
  String $fmw_home           = '/opt/oracle/middleware11g',
  String $source_path        = "/software",
  String $os_user            = 'oracle',
  String $os_group           = 'oracle',
  String $domain_name        = 'wls_domain',
  String $weblogic_user      = 'weblogic',
  String $weblogic_password  = 'welcome1',
  String $log_dir            = '/data/log',
  String  $adminserver_address = '10.10.10.10',
  Integer $adminserver_port    = 7001,
) {

  notice "class profile::wls1036_domain"

  class { 'orawls::weblogic':
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
    javaParameters             => '', # '-Dspace.detection=false'
  }

  /*
  exec { 'copydomain' :
    command   => "scp -oStrictHostKeyChecking=no -oCheckHostIP=no guest@$adminserver_address:/var/tmp/install/domain_${domain_name}.jar /var/tmp/install/domain_${domain_name}.jar",
    path      => "${jdk_home_dir}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin",
    user      => "guest",
    group     => "guest",
    logoutput => true,
  }
  */

  /*
  orawls::copydomain { 'default' :
    version                    => 1036,
    weblogic_home_dir          => "$fmw_home/wlserver_10.3",
    middleware_home_dir        => $fmw_home,
    jdk_home_dir               => "/usr/java/latest",
    wls_domains_dir            => "$fmw_home/user_projects/domains",
    wls_apps_dir               => "$fmw_home/user_projects/applications",
    use_ssh                    => false,
    download_dir               => "/var/tmp/install",
    os_user                    => $os_user,
    os_group                   => $os_group,
    log_dir                    => $log_dir,
    log_output                 => true,
    
    domain_name                => $domain_name,
    weblogic_user              => $weblogic_user,
    weblogic_password          => $weblogic_password,
    adminserver_address        => $adminserver_address,
    adminserver_port           => $adminserver_port,
  }
  */

  /*
  $use_ssh                    = true,
  $domain_pack_dir            = undef,
  $userConfigFile             = hiera('domain_user_config_file'   , undef),
  $userKeyFile                = hiera('domain_user_key_file'      , undef),
  $weblogic_user              = hiera('wls_weblogic_user'         , 'weblogic'),
  $weblogic_password          = hiera('domain_wls_password'       , undef),
  */

  /*
  orawls::storeuserconfig { 'default' :
    weblogic_home_dir          => "$fmw_home/wlserver_10.3",
    jdk_home_dir               => "/usr/java/latest",
    download_dir               => "/var/tmp/install",
    domain_name                => $domain_name,
    os_user                    => $os_user,
    os_group                   => $os_group,
    log_output                 => true,
    adminserver_address        => $adminserver_address,
    adminserver_port           => $adminserver_port,
    user_config_dir            => "/home/$os_user",
    weblogic_user              => $weblogic_user,
    weblogic_password          => $weblogic_password,
  }
  */

  /*
  wls_setting { 'default' :
    user                         => $os_user,
    weblogic_home_dir            => "$fmw_home/wlserver_10.3",
    connect_url                  => "t3://localhost:7001",
    weblogic_user                => $weblogic_user,
    weblogic_password            => $weblogic_password,
  }

  wls_domain { $domain_name :
    ensure                      => 'present',
    jpa_default_provider        => 'org.eclipse.persistence.jpa.PersistenceProvider',
    jta_max_transactions        => '20000',
    jta_transaction_timeout     => '30',
    log_file_min_size           => '5000',
    log_filecount               => '10',
    log_filename                => "/var/log/weblogic/$domain_name.log",
    log_number_of_files_limited => '1',
    log_rotate_logon_startup    => '1',
    log_rotationtype            => 'bySize',
    security_crossdomain        => '1',
  }

  wls_adminserver { 'AdminServer' :
    ensure                    => 'running',
    server_name               => 'AdminServer',
    domain_name               => $domain_name,
    domain_path               => "$fmw_home/user_projects/domains/$domain_name",
    os_user                   => $os_user,
    weblogic_home_dir         => "$fmw_home/wlserver_10.3",
    weblogic_user             => $weblogic_user,
    weblogic_password         => $weblogic_password,
    jdk_home_dir              => "/usr/java/latest",
    nodemanager_address       => "localhost",
    nodemanager_port          => 5556,
    refreshonly               => true,
    subscribe                 => Wls_domain[$domain_name]
  }
  */
    
}
