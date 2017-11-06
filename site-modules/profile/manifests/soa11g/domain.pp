class profile::soa11g::domain (
  String  $domain_name,
  String  $weblogic_user,
  String  $weblogic_password,
  String  $adminserver_address = $::hostname,
  String  $adminserver_name    = 'AdminServer',
  Hash    $machines            = {},
  Hash    $managed_servers     = {},
  String  $source_path         = '/software',
  String  $ora_home            = '/opt/oracle',
  String  $fmw_home            = '/opt/oracle/fmw11g',
  String  $os_user             = 'oracle',
  String  $os_group            = 'oracle',
  String  $log_dir             = '/data/log',
) {
notice "class profile::soa11g::domain"

class{'orautils':
    os_oracle_home      => "/opt/oracle",
    ora_inventory       => "/opt/oracle/oraInventory",
    os_domain_type      => "soa",
    os_log_folder       => "/data/log",
    os_download_folder  => "/data/install",
    os_mdw_home         => $fmw_home,
    os_wl_home          => "$fmw_home/wlserver_10.3",
    ora_user            => "oracle",
    ora_group           => "oracle",
    os_domain           => "osbSoaDomain",
    os_domain_path      => "$fmw_home/user_projects/domains/osbSoaDomain",
    node_mgr_path       => "$fmw_home/wlserver_10.3/server/bin",
    node_mgr_port       => 5556,
    node_mgr_address    => 'localhost',
    wls_user            => "weblogic",
    wls_password        => "welcome1",
    wls_adminserver     => "AdminServer",
    jsse_enabled        => false,
}
contain 'orautils'
  # class { 'wls::urandomfix' :}

 $jdkWls11gJDK = 'jdk1.7.0_80'
 $wls11gVersion = "1111"
 $puppetDownloadMntPoint = $source_path
 $osOracleHome = $ora_home
 $osMdwHome    = $fmw_home
 $osWlHome     = "$fmw_home/wlserver_10.3"
 $user         = $os_user
 $group        = $os_group
 $downloadDir  = $download_dir
 $logDir       = $log_dir
 $mtimeParam = "1"
 $wlsDomainName   = "soaDomain"
 $adminListenPort = "7001"
 $nodemanagerPort = "5556"
 # $address         = "localhost"
 $userConfigDir = '/home/oracle'
 # rcu soa repository
 $reposUrl        = "jdbc:oracle:thin:@10.10.10.5:1521/test.oracle.com"
 $reposPrefix     = "DEV"
 $reposPassword   = 'Welcome01'
 $userConfigFile = "${userConfigDir}/${user}-${wlsDomainName}-WebLogicConfig.properties"
 $userKeyFile    = "${userConfigDir}/${user}-${wlsDomainName}-WebLogicKey.properties"

 $wlsDomainsPath  = "$fmw_home/user_projects/domains"
 $osTemplate      = "osb_soa_bpm"
 $address         = "10.10.10.110"

->
# install
wls::installwls{'11gPS5':
  version                => $wls11gVersion,
  fullJDKName            => $jdkWls11gJDK,
  oracleHome             => $osOracleHome,
  mdwHome                => $osMdwHome,
  user                   => $user,
  group                  => $group,
  downloadDir            => $downloadDir,
  remoteFile             => false,
  puppetDownloadMntPoint => $puppetDownloadMntPoint,
  createUser             => false,
}
->
# weblogic patch
wls::bsupatch{'p17071663':
  mdwHome                => $osMdwHome,
  wlHome                 => $osWlHome,
  fullJDKName            => $jdkWls11gJDK,
  user                   => $user,
  group                  => $group,
  downloadDir            => $downloadDir,
  puppetDownloadMntPoint => $puppetDownloadMntPoint,
  patchId                => 'BYJ1',
  patchFile              => 'p17071663_1036_Generic.zip',
  remoteFile             => false,
  require                => Wls::Installwls['11gPS5'],
}
->
wls::installsoa{'soaPS6':
  mdwHome                => $osMdwHome,
  wlHome                 => $osWlHome,
  oracleHome             => $osOracleHome,
  fullJDKName            => $jdkWls11gJDK,
  user                   => $user,
  group                  => $group,
  downloadDir            => $downloadDir,
  puppetDownloadMntPoint => $puppetDownloadMntPoint,
  soaFile1               => 'ofm_soa_generic_11.1.1.9.0_disk1_1of2.zip',
  soaFile2               => 'ofm_soa_generic_11.1.1.9.0_disk1_2of2.zip',
  remoteFile             => false,
  require                => Wls::Bsupatch['p17071663'],
}
->
wls::opatch{'17014142_soa_patch':
  fullJDKName            => $jdkWls11gJDK,
  user                   => $user,
  group                  => $group,
  downloadDir            => $downloadDir,
  remoteFile             => false,
  puppetDownloadMntPoint => $puppetDownloadMntPoint,
  oracleProductHome      => "${osMdwHome}/Oracle_SOA1" ,
  patchId                => '17014142',
  patchFile              => 'p17014142_111170_Generic.zip',
  require                => Wls::Installsoa['soaPS6'],
}
->
wls::installosb{'osbPS6':
  mdwHome                => $osMdwHome,
  wlHome                 => $osWlHome,
  oracleHome             => $osOracleHome,
  fullJDKName            => $jdkWls11gJDK,
  user                   => $user,
  group                  => $group,
  downloadDir            => $downloadDir,
  puppetDownloadMntPoint => $puppetDownloadMntPoint,
  osbFile                => 'ofm_osb_generic_11.1.1.9.0_disk1_1of1.zip',
  remoteFile             => false,
  require                => Wls::Opatch['17014142_soa_patch'],
}
->
#nodemanager configuration and starting
wls::nodemanager{'nodemanager11g':
  wlHome        => $osWlHome,
  fullJDKName   => $jdkWls11gJDK,
  user          => $user,
  group         => $group,
  serviceName   => $serviceName,
  downloadDir   => $downloadDir,
  listenPort    => '5556',
  logDir        => $logDir,
  require       => Wls::Installosb['osbPS6'],
}


->
orautils::nodemanagerautostart{"autostart ${wlsDomainName}":
  version     => "1111",
  wlHome      => $osWlHome,
  user        => $user,
  logDir      => $logDir,
}


#--------------- DOMINIO
 ->
# install SOA OIM OAM domain
wls::wlsdomain{'soaDomain':
  version         => "1111",
  wlHome          => $osWlHome,
  mdwHome         => $osMdwHome,
  fullJDKName     => $jdkWls11gJDK,
  wlsTemplate     => $osTemplate,
  domain          => $wlsDomainName,
  developmentMode => false,
  adminServerName => "AdminServer",
  adminListenAdr  => $address,
  adminListenPort => $adminListenPort,
  nodemanagerPort => $nodemanagerPort,
  wlsUser         => "weblogic",
  password        => "welcome1",
  user            => $user,
  group           => $group,
  logDir          => $logDir,
  downloadDir     => $downloadDir,
  reposDbUrl      => $reposUrl,
  reposPrefix     => $reposPrefix,
  reposPassword   => $reposPassword,
}
->
Wls::Wlscontrol{
  wlsDomain     => $wlsDomainName,
  wlsDomainPath => "${wlsDomainsPath}/${wlsDomainName}",
  wlHome        => $osWlHome,
  fullJDKName   => $jdkWls11gJDK,
  wlsUser         => "weblogic",
  password        => "welcome1",
  address       => $address,
  user          => $user,
  group         => $group,
  downloadDir   => $downloadDir,
  logOutput     => true,
}
->
# start AdminServers for configuration of WLS Domain
wls::wlscontrol{'startAdminServer':
  wlsServerType => 'admin',
  wlsServer     => "AdminServer",
  action        => 'start',
  port          => $nodemanagerPort,
  require       => Wls::Wlsdomain['soaDomain'],
}
->
# create keystores for automatic WLST login
wls::storeuserconfig{'soaDomain_keys':
  wlHome        => $osWlHome,
  fullJDKName   => $jdkWls11gJDK,
  domain        => $wlsDomainName,
  address       => $address,
  wlsUser       => hiera('wls_weblogic_user'),
  password      => hiera('domain_wls_password'),
  port          => $adminListenPort,
  user          => $user,
  group         => $group,
  userConfigDir => $userConfigDir,
  downloadDir   => $downloadDir,
  require       => Wls::Wlscontrol['startAdminServer'],
}


}
