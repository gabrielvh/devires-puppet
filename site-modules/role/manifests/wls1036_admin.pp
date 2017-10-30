class role::wls1036_admin {
  include profile::java7
  include profile::wls1036_os
  include profile::wls1036_domain

  Class['profile::java7']
    -> Class['profile::wls1036_os']
      -> Class['profile::wls1036_domain']

}
