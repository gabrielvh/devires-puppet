class profile::ora12c::rcu (
  String  $server_address     = $::hostname,
  String  $server_name        = 'dbserver',
  Hash    $machines            = {},
  Hash    $managed_servers     = {},
  String  $source_path         = '/software',
  String  $os_user             = 'oracle',
  String  $download_dir        = '/var/tmp/install',
) {

  oradb::rcu{  'DEV_PS6':
                 rcuFile          => 'ofm_rcu_linux_11.1.1.7.0_64_disk1_1of1.zip',
                 product          => 'soasuite',
                 version          => '11.1.1.7',
                 user             => $os_user,
                 group            => 'oinstall',
                 downloadDir      => $download_dir,
                 action           => 'create',
                 dbServer         => '10.10.10.5:1521',
                 dbService        => 'test.oracle.com',
                 sysPassword      => 'Welcome01',
                 schemaPrefix     => 'DEV',
                 reposPassword    => 'Welcome01',
                 tempTablespace   => 'TEMP',
                 puppetDownloadMntPoint => $source_path,
                 remoteFile       => false,
                 logoutput        => true,
  }

}
