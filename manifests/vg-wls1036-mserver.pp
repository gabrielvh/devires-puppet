node 'vg-wls1036-mserver' {
  
  notice "environment ${environment}"
  
  $host_instances = hiera('hosts')
  create_resources('host', $host_instances, {})
  
  include 'role::wls1036_mserver'

}
