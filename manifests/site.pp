# jdk installation
package { "openjdk-7-jdk" :
  ensure => "present",
  require => Exec['apt-get update']
}

# serving the /etc/hosts to all the puppet clients: hadoop master + hadoop slaves
file {"/etc/hosts":
	owner  => "root",
	group  => "root",
	mode   => 0644,
	source => "puppet:///modules/hadoop/etc/hosts"
}

$hadoop_hdfs_data_dirs_puppet		= ["/data", "/data/1", "/data/1/dfs","/data/2", "/data/2/dfs"]
$hadoop_hdfs_data_dirs_erb		= ["/data/1/dfs/dn", "/data/2/dfs/dn"] # for templates

$hadoop_hdfs_name_dirs_puppet		= ["/data", "/data/1", "/data/1/dfs"]
$hadoop_hdfs_name_dirs_erb		= ["/data/1/dfs/nn"] #for templates

$hadoop_mapred_local_dirs_puppet	= ["/data/1/mapred",  "/data/2/mapred"] 
$hadoop_mapred_local_dirs_erb		= ["/data/1/mapred/local","/data/2/mapred/local"] #for templates

$exclude_hosts_file                     = ["/etc/hadoop/conf.cluster/excludes"]

include myrna
include cloudgene
include crossbow
#include adduser
import "nodes.pp"



