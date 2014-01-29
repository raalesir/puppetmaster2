# MYRNA  INSTALLATION


class myrna {

	$myrna_dir	= "/opt/myrna"
	$myrna_archive	= "myrna-1.2.0.zip"

	file {$myrna_dir:
		ensure	=> "directory",
		owner		=> "root",
		group		=> "root",
		mode		=> 755,
#		description	=> "creating the crossbow directory"
	}

#	exec {"download_crossbow":
#		command	=> "/usr/bin/wget http://sourceforge.net/projects/bowtie-bio/files/crossbow/1.2.0/crossbow-1.2.0.zip -P $crossbow_dir ",
#		require	=> File[$crossbow_dir],
#		creates	=> "$crossbow_dir/crossbow-1.2.0.zip"
#		description	=> "downloading the Crossbow"
#	}

#	package {"unzip":
#		ensure	=> "latest"
#	}	

	exec {"extract_myrna":
		command	=> "/usr/bin/unzip $myrna_dir/$myrna_archive -d $myrna_dir",
		creates => "$myrna_dir/myrna-1.2.0/",
		#require	=> [Exec["download_crossbow"], Package["unzip"]]
		require	=> [Package['unzip'], File['serve_myrna_archive']]
	}


	file {"serve_myrna_archive":
		path	=> "$myrna_dir/$myrna_archive" ,
		#ensure	=> "directory",
		#owner	=> "root",
		#group	=> "root",
		mode	=> 755,
		source	=> "puppet:///modules/myrna/$myrna_archive",
		require	=> File["$myrna_dir"]
	}

#	file {"fastq_dump":
#		path	=> "/usr/bin/fastq-dump",
#		mode		=> 755,
#		source	=> "puppet:///modules/crossbow/fastq-dump"
#	}

#	exec {"set_home_path":
#		command	=> "export CROSSBOW_HOME=$crossbow_dir/crossbow-1.2.0",
#		require	=> Exec["extract_crossbow"]
#	}
}

