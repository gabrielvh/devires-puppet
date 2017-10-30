class profile::wls1036_domain (
  String $ora_home           = '/opt/oracle',
  String $fmw_home           = '/opt/oracle/middleware11g',
  String $source_path        = "/software",
  String $os_user            = 'oracle',
  String $os_group           = 'oracle',
  String $domain_name        = 'wls_domain',
  String $weblogic_user      = 'weblogic',
  String $weblogic_password  = 'welcome1',
  String $log_dir            = '/data/log',
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

  orawls::domain { 'domain':
    version                    => 1036,
    weblogic_home_dir          => "$fmw_home/wlserver_10.3",
    middleware_home_dir        => $fmw_home,
    jdk_home_dir               => "/usr/java/latest",
    wls_domains_dir            => "$fmw_home/user_projects/domains",
    wls_apps_dir               => "$fmw_home/user_projects/applications",
    download_dir               => "/var/tmp/install",
    os_user                    => $os_user,
    os_group                   => $os_group,
    log_dir                    => $log_dir,
    log_output                 => true,
    domain_template            => 'standard',
    domain_name                => $domain_name,
    development_mode           => false,
    weblogic_user              => $weblogic_user,
    weblogic_password          => $weblogic_password,
    adminserver_name           => 'AdminServer',
    adminserver_address        => undef,
    adminserver_port           => 7001,
    java_arguments             => {},
    nodemanager_address        => undef,
    nodemanager_port           => 5556,
  }

  orawls::nodemanager { 'nodemanager':
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
  }

  orautils::nodemanagerautostart { 'nodemanagerautostart':
    version                   => 1036,
    wl_home                   => "$fmw_home/wlserver_10.3",
    log_dir                    => $log_dir,
    user                      => $os_user,
  }

  orawls::control { 'start':
    middleware_home_dir        => $fmw_home,
    weblogic_home_dir          => "$fmw_home/wlserver_10.3",
    wls_domains_dir            => "$fmw_home/user_projects/domains",
    jdk_home_dir               => "/usr/java/latest",
    download_dir               => "/var/tmp/install",
    domain_name                => $domain_name,
    os_user                    => $os_user,
    os_group                   => $os_group,
    log_output                 => true,
    weblogic_user              => $weblogic_user,
    weblogic_password          => $weblogic_password,
    nodemanager_port           => 5556,
    adminserver_port           => 7001,
    adminserver_address        => undef,
    server_type                => 'admin',
    target                     => 'Server',
    server                     => 'AdminServer',
    action                     => 'start',
  }

  orawls::storeuserconfig { 'default' :
    weblogic_home_dir          => "$fmw_home/wlserver_10.3",
    jdk_home_dir               => "/usr/java/latest",
    download_dir               => "/var/tmp/install",
    domain_name                => $domain_name,
    os_user                    => $os_user,
    os_group                   => $os_group,
    log_output                 => true,
    adminserver_address        => "localhost",
    adminserver_port           => 7001,
    user_config_dir            => "/home/$os_user",
    weblogic_user              => $weblogic_user,
    weblogic_password          => $weblogic_password,
  }

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
  }

  file { "/var/tmp/install/domain_$domain_name.jar" :
    ensure    => 'file',
    #owner    => 'guest',
    #group    => '$username',
    mode      => '774',
    require   => Orawls::Packdomain['default']
  }

  wls_setting { 'default' :
    require                      => Orawls::Control['start'],
    user                         => $os_user,
    weblogic_home_dir            => "$fmw_home/wlserver_10.3",
    connect_url                  => "t3://localhost:7001",
    weblogic_user                => $weblogic_user,
    weblogic_password            => $weblogic_password,
  }

  wls_domain { $domain_name :
    require                     => Orawls::Control['start'],
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
    require                   => Orawls::Control['start'],
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

}
