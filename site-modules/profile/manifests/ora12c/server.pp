Package{allow_virtual => false,}

class profile::ora12c::server (
  String  $server_address     = $::hostname,
  String  $server_name        = 'dbserver',
  Hash    $machines            = {},
  Hash    $managed_servers     = {},
  String  $source_path         = '/software',
  String  $ora_home            = '/opt/oracle',
  String  $fmw_home            = '/opt/oracle/db12c',
  String  $os_user             = 'oracle',
  String  $log_dir             = '/data/log',
  String  $download_dir        = '/var/tmp/install',
) {

    oradb::installdb{ '12.1_linux-x64':
            version                => '12.1.0.2',
            file                   => 'linuxamd64_12102_database_se2',
            databaseType           => 'SE',
            oracleBase             => $ora_home,
            oracleHome             => $fmw_home,
            userBaseDir            => "/home",
            createUser             => false,
            user                   => $os_user,
            group                  => 'dba',
            group_install          => 'oinstall',
            group_oper             => 'oper',
            downloadDir            => $download_dir,
            remoteFile             => false,
            puppetDownloadMntPoint => $source_path,
    }

   oradb::net{ 'config net8':
            oracleHome   => $fmw_home,
            version      => '12.1',
            user         => $os_user,
            group        => 'dba',
            downloadDir  => $download_dir,
            require      => Oradb::Installdb['12.1_linux-x64'],
   }

   oradb::listener{'start listener':
            oracleBase   => $ora_home,
            oracleHome   => $fmw_home,
            user         => $os_user,
            group        => 'dba',
            action       => 'start',
            require      => Oradb::Net['config net8'],
   }

   oradb::database{ 'testDb':
                    oracleBase              => $ora_home,
                    oracleHome              => $fmw_home,
                    version                 => '12.1',
                    user                    => $os_user,
                    group                   => 'dba',
                    downloadDir             => $download_dir,
                    action                  => 'create',
                    dbName                  => 'test',
                    dbDomain                => 'oracle.com',
                    sysPassword             => 'Welcome01',
                    systemPassword          => 'Welcome01',
                    dataFileDestination     => "$ora_home/oradata",
                    recoveryAreaDestination => "$ora_home/flash_recovery_area",
                    characterSet            => "AL32UTF8",
                    nationalCharacterSet    => "UTF8",
                    initParams              => "open_cursors=1000,processes=600,job_queue_processes=4,compatible=12.1.0.2.0",
                    sampleSchema            => 'TRUE',
                    memoryPercentage        => "40",
                    memoryTotal             => "800",
                    databaseType            => "MULTIPURPOSE",
                    require                 => Oradb::Listener['start listener'],
   }

   oradb::dbactions{ 'start testDb':
                   oracleHome              => $fmw_home,
                   user                    => $os_user,
                   group                   => 'dba',
                   action                  => 'start',
                   dbName                  => 'test',
                   require                 => Oradb::Database['testDb'],
   }

}
