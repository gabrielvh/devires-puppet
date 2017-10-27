class profile::java7 (
  String $jdk_version       = '7u80',
  String $jdk_full_version  = 'jdk1.7.0_80',
  String $source_path       = "/software",
) {

  notice "class profile::java7"

  $remove = [ "java-1.7.0-openjdk.x86_64", "java-1.6.0-openjdk.x86_64" ]

  package { $remove :
    ensure  => absent,
  }
  
  include jdk7
  jdk7::install7{ 'jdk7':
    version                => $jdk_version, 
    full_version           => $jdk_full_version,
    java_homes             => '/usr/java',
    download_dir           => '/var/tmp/install',
    source_path            => $source_path,
    alternatives_priority  => 18000,
    x64                    => true,
    urandom_java_fix       => true,
    rsa_key_size_fix       => true,  # set true for weblogic 12.1.1 and jdk 1.7 > version 40
  }
  
}
