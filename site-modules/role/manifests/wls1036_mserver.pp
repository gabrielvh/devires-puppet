class role::wls1036_mserver {
  include profile::java7
  include profile::wls1036_os
  include profile::wls1036_mserver

  Class['profile::java7']
    -> Class['profile::wls1036_os']
      -> Class['profile::wls1036_mserver']

}
