class profile::common {
  
  contain profile::common::packages
  contain profile::common::time
  contain profile::common::users
  
}
