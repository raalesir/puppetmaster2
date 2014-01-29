class hadoop::apt {
  Package['curl'] -> Exec["add_cloudera_repokey"]
  File["/etc/apt/sources.list.d/cloudera.list"] ~> Exec["add_cloudera_repokey"]  ~> Exec["apt-get update"]

  package { "curl":
    ensure => "latest",
  }

  file { "/etc/apt/sources.list.d/cloudera.list":
    owner  => "root",
    group  => "root",
    mode   => 0440,
    source => "puppet:///modules/hadoop/etc/apt/sources.list.d/cloudera.list",
  }

  exec { "add_cloudera_repokey":
    command     => "/usr/bin/curl -s http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh/archive.key | sudo apt-key add -",
    refreshonly => true
  }

  exec { "apt-get update":
    command     => "/usr/bin/apt-get -q -q update",
    logoutput   => false,
    refreshonly => true,
  }
}
