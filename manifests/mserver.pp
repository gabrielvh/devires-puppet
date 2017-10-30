node 'mserver' {
  
  notice "environment ${environment}"
  
  include role::mplus_common
  include role::wls1036_mserver
  
Class['role::mplus_common'] -> Class['role::wls1036_mserver']

}
