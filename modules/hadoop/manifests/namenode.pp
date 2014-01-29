#namenode.pp

class hadoop::namenode {
	require hadoop::base

	package { "hadoop-hdfs-namenode":
		ensure => "latest",
		require => Package["hadoop"],
	}

#  package { "hadoop-hdfs-secondarynamenode":
#    ensure => "latest",
#    require => Package["hadoop"],
#  }

	#for the description of hadoop_hdfs_name_dirs_puppet look into site.pp
	file { $hadoop_hdfs_name_dirs_puppet: # ["/data", "/data/1", "/data/1/dfs"]: 
		ensure	=> directory,
		group		=> hdfs,
		owner		=> hdfs,
		mode		=> 755
	}


	#for the description of hadoop_hdfs_name_dirs_erb look into site.pp
	file { $hadoop_hdfs_name_dirs_erb: #["/data/1/dfs/nn" ,"/nfsmount/dfs/nn"]:
		ensure  => directory,	
		group   => hdfs,
		owner   => hdfs,
		mode    => 700
	}


	exec { "format-name-node":
		command => "/usr/bin/yes Y |/usr/bin/hadoop namenode -format",
		user => "hdfs",
		creates => "$hadoop_hdfs_name_dirs_erb/current",
		require => [ Package["hadoop-hdfs-namenode"],File[$hadoop_hdfs_name_dirs_erb],],
	}

	

	service { "hadoop-hdfs-namenode":
		ensure => "running",
		require => [ Exec["format-name-node"], File["/var/log/hadoop-hdfs"]]
	}

 # service { "hadoop-hdfs-secondarynamenode":
 #   ensure => "running",
 #   require => Service["hadoop-hdfs-namenode"],
 # }


         
	##############################################
	# creating Hadoop user "hadoopuser:hadoopuser"
	##############################################
#	$HU="hadoopuser"
#
#	exec{"create_hadoop_user_home" :
#		command	=> "/usr/bin/hadoop fs -mkdir /user/$HU",
#		user	=> "hdfs",
#		creates => "/user/$HU",
#		require	=> Service["hadoop-hdfs-namenode"],
#	}
#
#	exec {"chown_user_home":
#		command	=> "/usr/bin/hadoop fs -chown $HU:$HU /user/$HU",
#		user	=> "hdfs",
#		require	=> Exec["create_hadoop_user_home"]
#	}
	##############################################
}
