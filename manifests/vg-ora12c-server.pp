node 'vg-ora12c-server' {

  notice "environment ${environment}"

  $host_instances = hiera('hosts')
  create_resources('host', $host_instances)

  include role::ora12c_server

  Host <||> -> Class['role::ora12c_server']

}
