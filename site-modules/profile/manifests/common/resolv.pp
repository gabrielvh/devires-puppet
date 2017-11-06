class profile::common::resolv {

  notice "class profile::common::resolv"

  class { 'resolv_conf' :
    nameservers   => [ '172.22.164.1' , '172.22.164.2' ],
    searchpath    => [ 'qa.multiplus.dtcenter' , 'multiplus.dtcenter' ],
  }

}
