class profile::common::time {
  
  notice "class profile::common::time"

  include ntp

  class { 'timezone' :
    timezone => 'America/Sao_Paulo',
  }

}
