class hadoop::base {

  require hadoop::package




     #create /cloudgene/raalesir folde
   

	$cloudgeneUser = "raalesir"
	$cloudgeneGroup = "2013023"

	#group { $cloudgeneUser:
	#	ensure => "present",
	#}
 	user { "$cloudgeneUser":
		ensure		=> "present",
#		gid		=> "$cloudgenUser",
	}

	file { "/cloudgene/$cloudgeneUser":
                ensure  => directory,
                group   => $cloudgeneUser,
                owner   => $cloudgeneUser,
                recurse => true,
                mode    => 755
        }

     #

#########################################################
# create a linux user 'hadoopuser' and his home directory
#########################################################
	$user = 'hadoopuser'
	group { $user:
		ensure => "present",
	}
 	user { "$user":
		ensure		=> "present",
		gid		=> "$user",
		managehome 	=> true,
	}

	$user1 = 'hdfs'
	group { $user1:
		ensure => "present",
	}
 	
	group { "supergroup":                  
		ensure => "present",
	}


	user { "$user1":
		ensure          => "present",
		groups		=> "supergroup",
		gid             => "$user1",
		managehome      => true,
	}       


        group { "mapred":
                ensure => "present",
        }

	user { "mapred":
		ensure          => "present",
		groups		=> "supergroup",
		gid             => "mapred",
		managehome      => true,
	}       




	File {
		owner => root,
		group => root,
		mode  => 755,
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

	file {"/var/log/hadoop-hdfs":
		ensure	=> directory,
		group	=> hdfs,
		owner	=> hdfs,
		recurse	=> true,
		mode	=> 755
	}


	file {"/var/log/hadoop-0.20-mapreduce":
		ensure  => directory,
		group   => mapred,
		owner   => mapred,
		recurse => true,
		mode    => 755
	}




	#serve the file with "START=yes" for puppet client 
	# in ordet to be able to use "service puppet start"
	file{"/etc/default/puppet":
		ensure	=>file,
		group	=>root,
		owner	=>root,
		mode	=> 644,
		source	=> "puppet:///modules/hadoop/etc/default/puppet"
	}
         
}
