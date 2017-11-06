node 'vg-soa11g-mserver' {

  notice "environment ${environment}"

  $host_instances = hiera('hosts')
  create_resources('host', $host_instances)

  include 'role::soa11g_mserver'

  Host <||> -> Class['role::soa11g_mserver']

}
