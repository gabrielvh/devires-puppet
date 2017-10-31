node 'vg-wls1036-admin' {
  
  notice "environment ${environment}"

  $host_instances = hiera('hosts')
  create_resources('host', $host_instances, {})
  
  include role::wls1036_domain

  class { 'profile::wls1036::domain_mserveradd' :
    domain_name                 => 'wls_domain',
    weblogic_user               => 'weblogic',
    weblogic_password           => 'welcome1',
    mserver_name                => 'mserver_1',
    mserver_port                => '8001',
    machine_name                => 'RemoteMachine',
  }
  
  Class['role::wls1036_domain']
    -> Class['profile::wls1036::domain_mserveradd']

}
