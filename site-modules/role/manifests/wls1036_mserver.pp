class role::wls1036_mserver (
  String  $adminserver_address,
  String  $domain_name          = 'wls_domain',
  String  $weblogic_user        = 'weblogic',
  String  $weblogic_password    = 'welcome1',
  String  $mserver_name         = 'mserver_1',
  String  $mserver_port         = '8001',
  String  $machine_name         = 'RemoteMachine',
) {
  
  include profile::common
  include profile::java7
  include profile::wls1036::system

  class { 'profile::wls1036::mserver' :
    domain_name                 => $domain_name,
    weblogic_user               => $weblogic_user,
    weblogic_password           => $weblogic_password,
    mserver_name                => $mserver_name,
    mserver_port                => $mserver_port,
    machine_name                => $machine_name,
    adminserver_address         => $adminserver_address,
  }

  Class['profile::common']
    -> Class['profile::java7']
      -> Class['profile::wls1036::system']
        -> Class['profile::wls1036::mserver']

}
