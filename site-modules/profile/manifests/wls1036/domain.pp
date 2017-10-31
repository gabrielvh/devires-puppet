class profile::wls1036::domain (
  String  $domain_name,
  String  $weblogic_user,
  String  $weblogic_password,
  String  $adminserver_address = "$hostname",
  String  $adminserver_name    = 'AdminServer',
  String  $source_path         = '/software',
  String  $ora_home            = '/opt/oracle',
  String  $fmw_home            = '/opt/oracle/fmw11g',
  String  $os_user             = 'oracle',
  String  $os_group            = 'oracle',
  String  $log_dir             = '/data/log',
) {

  notice "class profile::wls1036::domain"

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

  orawls::domain { 'default' :
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
    adminserver_name           => $adminserver_name,
    adminserver_address        => undef,
    adminserver_port           => 7001,
    java_arguments             => {},
    nodemanager_address        => undef,
    nodemanager_port           => 5556,
    require                    => Class['orawls::weblogic']
  }

  orawls::nodemanager { 'default' :
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
    nodemanager_address        => undef,
    nodemanager_port           => 5556,
    require                    => Orawls::Domain['default']
  }

  orautils::nodemanagerautostart { 'nmautostart' :
    version                   => 1036,
    wl_home                   => "$fmw_home/wlserver_10.3",
    log_dir                   => $log_dir,
    user                      => $os_user,
    require                   => Orawls::Nodemanager['default']
  }

  orawls::control { 'start' :
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
    adminserver_address        => 'localhost',
    adminserver_port           => 7001,
    server_type                => 'admin',
    target                     => 'Server',
    server                     => $adminserver_name,
    action                     => 'start',
    require                    => Orautils::Nodemanagerautostart['nmautostart']
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
    require                    => Orawls::Control['start'],
  }

  wls_setting { 'default' :
    user                         => $os_user,
    weblogic_home_dir            => "$fmw_home/wlserver_10.3",
    connect_url                  => "t3://localhost:7001",
    weblogic_user                => $weblogic_user,
    weblogic_password            => $weblogic_password,
    require                      => Orawls::Control['start'],
  }

  wls_domain { $domain_name :
    ensure                      => 'present',
    jpa_default_provider        => 'org.eclipse.persistence.jpa.PersistenceProvider',
    jta_max_transactions        => '20000',
    jta_transaction_timeout     => '30',
    log_file_min_size           => '5000',
    log_filecount               => '10',
    log_filename                => "$log_dir/$domain_name.log",
    log_number_of_files_limited => '1',
    log_rotate_logon_startup    => '1',
    log_rotationtype            => 'bySize',
    security_crossdomain        => '1',
    require                     => Wls_setting['default'],
  }

  wls_adminserver { $adminserver_name :
    ensure                    => 'running',
    server_name               => $adminserver_name,
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
    require                   => Wls_setting['default'],
    subscribe                 => [ Wls_domain[$domain_name] , Wls_server[$adminserver_name] ],
  }

  wls_machine { 'LocalMachine' :
    ensure        => 'present',
    listenaddress => 'localhost',
    listenport    => '5556',
    machinetype   => 'UnixMachine',
    nmtype        => 'SSL',
    require       => Wls_setting['default']
  }

  wls_server { $adminserver_name :
    ensure                            => 'present',
    arguments                         => "-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=$log_dir/${adminserver_name}.out -Dweblogic.Stderr=$log_dir/${adminserver_name}_err.out",
    listenaddress                     => $adminserver_address,
    listenport                        => '7001',
    machine                           => 'LocalMachine',
    logfilename                       => "$log_dir/${adminserver_name}.log",
    log_http_filename                 => "$log_dir/${adminserver_name}_access.log",
    log_datasource_filename           => "$log_dir/${adminserver_name}_datasource.log",
    log_file_min_size                 => '2000',
    log_filecount                     => '10',
    log_number_of_files_limited       => '1',
    log_rotate_logon_startup          => '1',
    log_rotationtype                  => 'bySize',
    max_message_size                  => '10000000',
    jsseenabled                       => '0',
    sslenabled                        => '0',
    require                           => Wls_machine['LocalMachine'],
  }

}