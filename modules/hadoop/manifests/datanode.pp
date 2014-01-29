class hadoop::datanode {

	require hadoop::base


	package { "hadoop-hdfs-datanode":
		ensure => "latest",
	}

	# for $hadoop_hdfs_data_dirs_puppet look in the site.pp
	file {$hadoop_hdfs_data_dirs_puppet : #["/data", "/data/1", "/data/1/dfs",	"/data/2", "/data/2/dfs","/data/3", "/data/3/dfs"]:
		ensure	=> directory,
		owner	=> hdfs,
		group	=> hdfs,
#		recurse	=> true,
		mode	=> 755, # has to be 755 for mapred to function 
		require	=> Package["hadoop-hdfs-datanode"],
	}


	# for $hadoop_hdfs_data_dirs_puppet look in the site.pp
	file { $hadoop_hdfs_data_dirs_erb:
		ensure => directory,
		owner => hdfs,
		group => hdfs,
		mode => 644, #was 700
#		recurse => true,
		require => Package["hadoop-hdfs-datanode"],	
	}


	service { "hadoop-hdfs-datanode":
		ensure => "running",
		require => [ Package["hadoop-hdfs-datanode"],
		File[$hadoop_hdfs_data_dirs_puppet], File[$hadoop_hdfs_data_dirs_erb] ],	
	}

}
