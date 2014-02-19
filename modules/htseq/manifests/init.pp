# HTseq  INSTALLATION


class htseq {

	$soft			= "HTSeq"
	$tmp			= "htseq" # module name should start with NO capital. strange...
	$version		= "0.5.4p5"
	$dir			= "/opt/$soft"
	$archive		= "HTSeq-0.5.4p5.tar.gz"

	file {$dir:
		ensure	=> "directory",
		owner		=> "root",
		group		=> "root",
		mode		=> 755,
	}

#	exec {"download_crossbow":
#		command	=> "/usr/bin/wget http://sourceforge.net/projects/bowtie-bio/files/crossbow/1.2.0/crossbow-1.2.0.zip -P $crossbow_dir ",
#		require	=> File[$crossbow_dir],
#		creates	=> "$crossbow_dir/crossbow-1.2.0.zip"
#		description	=> "downloading the Crossbow"
#	}

	package {"build-essential":
		ensure =>"latest"
	}	

	package {"python2.7-dev":
		ensure	=> "latest"
	}	

	package {"python-numpy":
		ensure	=> "latest"
	}	

	package {"python-matplotlib":
		ensure	=> "latest"
	}	

	exec {"extract_soft":
		cwd	=>	"$dir",
		command	=> "/bin/tar -xf $dir/$archive ",
		creates => "$dir/$soft-$version/",
		require	=> File['serve_archive']
	}


	file {"serve_archive":
		path	=> "$dir/$archive" ,
		#ensure	=> "directory",
		#owner	=> "root",
		#group	=> "root",
		mode	=> 755,
		source	=> "puppet:///modules/$tmp/$archive",
		require	=> File["$dir"]
	}

#	file {"fastq_dump":
#		path	=> "/usr/bin/fastq-dump",
#		mode		=> 755,
#		source	=> "puppet:///modules/crossbow/fastq-dump"
#	}


	exec{"build_soft":
		command	=>	"python setup.py build",
		cwd	=>	"${dir}/${soft}-${version}",
		creates	=>	"$dir/${soft}-${version}/build",
		require	=>	Exec["extract_soft"],
		path	=>	["/usr/bin/"]
	}

	exec {"install":
		command	=>	"sudo python setup.py install",
		cwd	=>	"${dir}/${soft}-${version}",
		creates	=>	"/usr/bin/htseq-count",
		require	=>	Exec["build_soft"],
		user	=>	"root",
		path	=>	["/usr/bin/"]
	}
	


#        exec {"make_link":
#                command => "/bin/ln -s $dir/$soft-$version /bin/linux64/bowtie /usr/bin/bowtie",
#		creates	=> "/usr/bin/bowtie",
#                require => Exec["extract_crossbow"]
#        }

#        exec {"make_soapsnp_link":
#                command => "/bin/ln -s $crossbow_dir/crossbow-1.2.0/bin/linux64/soapsnp /usr/bin/soapsnp",
#        	creates	=> "/usr/bin/soapsnp",
#		require => Exec["extract_crossbow"]
#        }                          


#	exec {"set_home_path":
#		command	=> "export CROSSBOW_HOME=$crossbow_dir/crossbow-1.2.0",
#		require	=> Exec["extract_crossbow"]
#	}
}

