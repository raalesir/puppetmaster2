# CROSSBOW  INSTALLATION


class crossbow {

	$crossbow_dir		= "/opt/crossbow"
	$crossbow_archive	= "crossbow-1.2.0.zip"

	file {$crossbow_dir:
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

	package {"pigz":
		ensure =>"latest"
	}	

	package {"unzip":
		ensure	=> "latest"
	}	

	exec {"extract_crossbow":
		command	=> "/usr/bin/unzip $crossbow_dir/$crossbow_archive -d $crossbow_dir",
		creates => "$crossbow_dir/crossbow-1.2.0/",
		#require	=> [Exec["download_crossbow"], Package["unzip"]]
		require	=> [Package['unzip'], File['serve_crossbow_archive']]
	}


	file {"serve_crossbow_archive":
		path	=> "$crossbow_dir/$crossbow_archive" ,
		#ensure	=> "directory",
		#owner	=> "root",
		#group	=> "root",
		mode	=> 755,
		source	=> "puppet:///modules/crossbow/$crossbow_archive",
		require	=> File["$crossbow_dir"]
	}

	file {"fastq_dump":
		path	=> "/usr/bin/fastq-dump",
		mode		=> 755,
		source	=> "puppet:///modules/crossbow/fastq-dump"
	}


        exec {"make_bowtie_link":
                command => "/bin/ln -s $crossbow_dir/crossbow-1.2.0/bin/linux64/bowtie /usr/bin/bowtie",
		creates	=> "/usr/bin/bowtie",
                require => Exec["extract_crossbow"]
        }

        exec {"make_soapsnp_link":
                command => "/bin/ln -s $crossbow_dir/crossbow-1.2.0/bin/linux64/soapsnp /usr/bin/soapsnp",
        	creates	=> "/usr/bin/soapsnp",
		require => Exec["extract_crossbow"]
        }                          


#	exec {"set_home_path":
#		command	=> "export CROSSBOW_HOME=$crossbow_dir/crossbow-1.2.0",
#		require	=> Exec["extract_crossbow"]
#	}
}

