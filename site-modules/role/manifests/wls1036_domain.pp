class role::wls1036_domain (
  String  $domain_name          = 'wls_domain',
  String  $weblogic_user        = 'weblogic',
  String  $weblogic_password    = 'welcome1',
  Hash    $machines             = {},
  Hash    $managed_servers      = {},
) {
  
  include profile::common
  include profile::java7
  include profile::wls1036::system

  class { 'profile::wls1036::domain' :
    domain_name             => $domain_name,
    weblogic_user           => $weblogic_user,
    weblogic_password       => $weblogic_password,
    machines                => $machines,
    managed_servers         => $managed_servers,
  }

  Class['profile::common']
    -> Class['profile::java7']
      -> Class['profile::wls1036::system']
        -> Class['profile::wls1036::domain']

}
