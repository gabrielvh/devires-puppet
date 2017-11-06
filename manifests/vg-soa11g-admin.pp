node 'vg-soa11g-admin' {

  notice "environment ${environment}"

  $host_instances = hiera('hosts')
  create_resources('host', $host_instances)

  include role::soa11g_domain

  Host <||> -> Class['role::soa11g_domain']

}
