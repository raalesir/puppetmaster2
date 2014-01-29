group { "puppet":
  ensure => "present",
}

exec { 'apt-get update':
  command => '/usr/bin/apt-get update',
}

# jdk installation
package { "openjdk-7-jdk" :
  ensure => "present",
  require => Exec['apt-get update']
}

