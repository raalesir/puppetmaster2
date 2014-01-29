#The only dependency outside the hadoop module is java in hadoop::package

class hadoop::datanode {
  require hadoop::base
  package { "hadoop-hdfs-datanode":
    ensure => "latest",
  }
  file { ["/data/1/dfs/dn", "/data/2/dfs/dn", "/data/3/dfs/dn"]:
    ensure => directory,
    owner => hdfs,
    group => hadoop,
    require => Package["hadoop-hdfs-datanode"],
  }
  service { "hadoop-hdfs-datanode":
    ensure => "running",
    require => [ Package["hadoop-hdfs-datanode"],
                 File["/data/1/dfs/dn"],
               ],
  }
}

class hadoop::tasktracker {
  require hadoop::base
  package { "hadoop-0.20-mapreduce-tasktracker":
    ensure => "latest",
  }
#  file { ["/data0/mapred", "/data0/mapred/local"]:
  file { ["/data/1/mapred/local","/data/2/mapred/local","/data/3/mapred/local"]:
    ensure => directory,
    owner => mapred,
    group => hadoop,
    require => Package["hadoop-0.20-mapreduce-tasktracker"],
  }

  service { "hadoop-0.20-mapreduce-tasktracker":
    ensure => "running",
    require => [ Package["hadoop-0.20-mapreduce-tasktracker"],
                 File["/data/1/mapred/local"],
               ],
  }
}

class hadoop::namenode {
  require hadoop::base
  package { "hadoop-hdfs-namenode":
    ensure => "latest",
    require => Package["hadoop"],
  }
  package { "hadoop-hdfs-secondarynamenode":
    ensure => "latest",
    require => Package["hadoop"],
  }

 # file { ["/var/hadoop","/var/hadoop/dfs", "/var/hadoop/dfs/name"]:
   file { ["/data/1/dfs/nn", "/nfsmount/dfs/nn"]: 
   ensure => directory,
   owner  => 'hdfs'
  }


  exec { "format-name-node":
    command => "/usr/bin/hadoop namenode -format",
    user => "hdfs",
    creates => "/data/1/dfs/nn/current",
    require => [ Package["hadoop-hdfs-namenode"],
                 File["/data/1/dfs/nn"],
               ],
  }

  service { "hadoop-hdfs-namenode":
    ensure => "running",
    require => Exec["format-name-node"],
  }

  service { "hadoop-hdfs-secondarynamenode":
    ensure => "running",
    require => Service["hadoop-hdfs-namenode"],
  }
}



class hadoop::jobtracker {
  require hadoop::base

  package { "hadoop-0.20-mapreduce-jobtracker":
    ensure => "latest",
  }

#  file { ["/data0/mapred", "/data0/mapred/local"]:
  file { ["/data/1/mapred/local","/data/2/mapred/local","/data/3/mapred/local"]:
    ensure => directory,
    owner => mapred,
    group => hadoop,
    require => Package["hadoop-0.20-mapreduce-jobtracker"],
  }



  exec {"mapred-var-dir":
	command => "/usr/bin/hadoop fs -mkdir -R /var/lib/hadoop-hdfs/cache/mapred/mapred/staging"
	user	=> "hdfs",
	unless	=> "/usr/bin/hadoop fs -ls /var/lib/hadoop-hdfs/cache/mapred/mapred/staging"
	require => Service["hadoop-hdfs-namenode"],
  }

	
  exec {"chmod-mapred-var-dir":
	command	=> "/usr/bin/hadoop fs -chmod 1777 /var/lib/hadoop-hdfs/cache/mapred/mapred/staging"
	require	=> Exec["mapred-var-dir"]
  }


  exec { "mapred-owns-its-dirs":
	command => "/usr/bin/hadoop fs -chown -R mapred:hadoop /var/lib/hadoop-hdfs/cache/mapred",
	user => "hdfs",
	require => Exec["mapred-var-dir"]
  }


 sudo -u hdfs hadoop fs -mkdir /tmp
 sudo -u hdfs hadoop fs -chmod -R 1777 /tmp

sudo -u hdfs hadoop fs -mkdir /tmp/mapred/system
 sudo -u hdfs hadoop fs -chown mapred:hadoop /tmp/mapred/system




  exec { "mapred-system-dir":
    command => "/usr/bin/hadoop fs -mkdir /tmp/hadoop-mapred/mapred/system",
    user => "hdfs",
    unless => "/usr/bin/hadoop fs -ls /tmp/hadoop-mapred/mapred/system",
    require => Service["hadoop-hdfs-namenode"],
  }

  exec { "mapred-staging-dir":
    command => "/usr/bin/hadoop fs -mkdir /tmp/hadoop-mapred/mapred/staging",
    user => "hdfs",
    unless => "/usr/bin/hadoop fs -ls /tmp/hadoop-mapred/mapred/staging",
    require => Service["hadoop-hdfs-namenode"],
  }

  exec { "mapred-temp-dir":
    command => "/usr/bin/hadoop fs -mkdir /tmp/hadoop-mapred/mapred/temp",
    user => "hdfs",
    unless => "/usr/bin/hadoop fs -ls /tmp/hadoop-mapred/mapred/temp",
    require => Service["hadoop-hdfs-namenode"],
  }



  service { "hadoop-0.20-mapreduce-jobtracker":
    ensure => "running",
    require => [ Package["hadoop-0.20-mapreduce-jobtracker"],
                 Exec["mapred-owns-its-dirs"],
                 File["/data0/mapred/local"],
               ],
  }
}


class hadoop::base {
  require hadoop::package
  user { "vagrant":
    groups => "hadoop",
  }
  File {
    owner => root,
    group => root,
    mode  => 755,
  }
  file { "/etc/hosts":
    source => "puppet:///modules/hadoop/etc/hosts",
    ensure => "file",
    mode => "0744",
  }
  file { "/etc/hadoop/conf.cluster/":
    ensure  => directory,
    source  => 'puppet:///modules/hadoop/etc/hadoop/conf.cluster/',
    recurse => true,
  }
  file { "hdfs-site":
    path    => "/etc/hadoop/conf.cluster/hdfs-site.xml",
    ensure  => file,
    content => template("hadoop/hdfs-site.xml.erb"),
  }
  file { "mapred-site":
    path    => "/etc/hadoop/conf.cluster/mapred-site.xml",
    ensure  => file,
    content => template("hadoop/mapred-site.xml.erb"),
  }
  file { "/etc/sysctl.d/60-reboot":
    ensure  => file,
    content => "kernel.panic = 10",
  }
  exec { "update_hadoop_alternative_conf":
    command => "/usr/sbin/update-alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.cluster 99",
    require => File["/etc/hadoop/conf.cluster"],
  }
}

class hadoop::package {
  require hadoop::apt,java
  package { "hadoop":
    ensure => "latest",
  }
}

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


