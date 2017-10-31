node 'vg-wls1036-mserver' {
  
  notice "environment ${environment}"
  
  $host_instances = hiera('hosts')
  create_resources('host', $host_instances, {})
  
  class { 'role::wls1036_mserver' :
    adminserver_address         => '10.10.10.10',
    domain_name                 => 'wls_domain',
    weblogic_user               => 'weblogic',
    weblogic_password           => 'welcome1',
    mserver_name                => 'mserver_1',
    mserver_port                => '8001',
    machine_name                => 'RemoteMachine',
  }

}
