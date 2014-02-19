#tasktacker.pp

class hadoop::tasktracker {
	require hadoop::base

	package { "hadoop-0.20-mapreduce-tasktracker":
		ensure => "latest",
	}

	# $hadoop_mapred_local_dirs_puppet description is in site.pp file
	file { $hadoop_mapred_local_dirs_puppet: #["/data/1/mapred", "/data/1/mapred/local",
		#"/data/2/mapred", "/data/2/mapred/local", "/data/3/mapred", "/data/3/mapred/local"]:
		ensure  => directory,
		owner   => mapred,	
		group   => mapred, # was hadoop,                                                                                                  
		mode    => 755,
#		recurse	=> true,
		require => Package["hadoop-0.20-mapreduce-tasktracker"],
	}


	service { "hadoop-0.20-mapreduce-tasktracker":
		ensure => "running",
		require => [ Package["hadoop-0.20-mapreduce-tasktracker"], File[$hadoop_mapred_local_dirs_puppet]],
	}
}

