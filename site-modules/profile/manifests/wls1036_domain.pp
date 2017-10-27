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
    jdk_home_dir               => "/usr/java/latest",
    os_user                    => $os_user,
    os_group                   => $os_group,
    download_dir               => "/var/tmp/install",
    temp_directory             => "/var/tmp/install",
    remote_file                => false,
    log_output                 => true,
  }

  orawls::domain { 'domain':
    version                    => 1036,
    domain_template            => 'standard',
    domain_name                => $domain_name,
    middleware_home_dir        => $fmw_home,
    weblogic_home_dir          => "$fmw_home/wlserver_10.3",
    jdk_home_dir               => "/usr/java/latest",
    wls_domains_dir            => "$fmw_home/user_projects/domains",
    wls_apps_dir               => "$fmw_home/user_projects/applications",
    download_dir               => "/var/tmp/install",
    log_output                 => true,
    os_user                    => $os_user,
    os_group                   => $os_group,
    log_dir                    => $log_dir,
    development_mode           => false,
    weblogic_user              => $weblogic_user,
    weblogic_password          => $weblogic_password,
  }
  
}
