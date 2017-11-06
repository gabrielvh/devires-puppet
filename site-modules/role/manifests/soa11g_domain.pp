class role::soa11g_domain (
  String  $domain_name          = 'soa_domain',
  String  $weblogic_user        = 'weblogic',
  String  $weblogic_password    = 'welcome1',
  Hash    $machines             = {},
  Hash    $managed_servers      = {},
) {

  include profile::common
  include profile::java7
  include profile::soa11g::system

  class { 'profile::soa11g::domain' :
    domain_name             => $domain_name,
    weblogic_user           => $weblogic_user,
    weblogic_password       => $weblogic_password,
    machines                => $machines,
    managed_servers         => $managed_servers,
  }

  Class['profile::common']
    -> Class['profile::java7']
      -> Class['profile::soa11g::system']
        -> Class['profile::soa11g::domain']

}
