class profile::common {
  
  contain 'profile::common::packages'
  contain 'profile::common::time'
  contain 'profile::common::users'
  contain 'profile::common::sudoers'

  if ($::environment != 'vagrant') {  
    contain 'profile::common::resolv'
  }
  
}
