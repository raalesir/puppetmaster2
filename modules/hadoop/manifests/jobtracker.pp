#jobtracker.pp

class hadoop::jobtracker {
	require hadoop::base

	package { "hadoop-0.20-mapreduce-jobtracker":
		ensure => "latest",
	}

	# $hadoop_mapred_local_dirs_puppet is in the site.pp file
	file { $hadoop_mapred_local_dirs_puppet : #["/data/1/mapred", "/data/1/mapred/local",
	     # "/data/2", "/data/2/mapred", "/data/2/mapred/local",  # "/data/3", "/data/3/mapred", "/data/3/mapred/local"]:
		ensure => directory,
		owner => mapred,
		group => hadoop,
		mode  =>644, #was 755,
		require => Package["hadoop-0.20-mapreduce-jobtracker"],
	}


	exec { "mapred-tmp-dir":
		command => "/usr/bin/hadoop fs -mkdir /tmp/hadoop",
		user => "mapred",
		unless => "/usr/bin/hadoop fs -ls /tmp/hadoop",
		require => Service["hadoop-hdfs-namenode"],
	}


	exec { "mapred-chmod-temp-dir":
		command => "/usr/bin/hadoop fs -chmod  -R 1777   /tmp",
		user => "mapred",
		require => Exec["mapred-tmp-dir"]
	}



	exec {"mapred-var-dir":
		command => "/usr/bin/hadoop fs -mkdir -p /var/lib/hadoop-hdfs/cache/mapred/mapred/staging",
		user  => "hdfs",
		unless  => "/usr/bin/hadoop fs -ls /var/lib/hadoop-hdfs/cache/mapred/mapred/staging",
		require => Service["hadoop-hdfs-namenode"],
	}

	exec {"chmod-mapred-var-dir":
		command => "/usr/bin/hadoop fs -chmod 1777 /var/lib/hadoop-hdfs/cache/mapred/mapred/staging",
		user  => "hdfs",
		require => Exec["mapred-var-dir"]
	}



#	exec { "hdfs-owns-its-dirs":
#		command => "/usr/bin/hadoop fs -chown -R hdfs:hadoop /var",
#		user => "hdfs",
#		require => Exec["mapred-var-dir"]
#	}	

	exec { "mapred-owns-its-dirs":
		command => "/usr/bin/hadoop fs -chown -R mapred /var/lib/hadoop-hdfs/cache/mapred",
		user => "hdfs",
		require => [ Exec["mapred-var-dir"]]#, Exec["hdfs-owns-its-dirs"] ]
	}




	exec { "mapred-system-dir":
		command => "/usr/bin/hadoop fs -mkdir  /tmp/hadoop/mapred/system",
		user => "hdfs",
 		unless => "/usr/bin/hadoop fs -ls /tmp/hadoop/mapred/system",
		require => Service["hadoop-hdfs-namenode"],
	}

#	exec {"chmod-mapred-tmp-dir":
#    command => "/usr/bin/hadoop fs -chmod 0700 /tmp/mapred/system",
#		user	=> "hdfs",   
#		require => Exec["mapred-system-dir"]
#  }
	exec { "mapred-owns-its-temp-dirs":
		command => "/usr/bin/hadoop fs -chown  mapred /tmp/hadoop/mapred/system",
		user => "hdfs",
		require => Exec["mapred-system-dir"]
	}



	service { "hadoop-0.20-mapreduce-jobtracker":
		ensure => "running",
		require => [ Package["hadoop-0.20-mapreduce-jobtracker"],
								Exec["mapred-chmod-temp-dir"],
								Exec["chmod-mapred-var-dir"],
								Exec["mapred-owns-its-dirs"],
#								File[$hadoop_mapred_local_dirs_puppet],
								Exec["mapred-owns-its-temp-dirs"],
               ],	
	}
}


