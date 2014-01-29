# CLOUDGENE  INSTALLATION


class cloudgene {

	$cloudgene_dir	= "/cloudgene"
	$cloudgene_archive	= "cloudgene-0.3.0.zip"

	file {$cloudgene_dir:
		ensure	=> "directory",
		owner		=> "hdfs",
		group		=> "supergroup",
		recurse		=> "true",
		mode		=> 755,
	}

#	exec {"download_crossbow":
#		command	=> "/usr/bin/wget http://sourceforge.net/projects/bowtie-bio/files/crossbow/1.2.0/crossbow-1.2.0.zip -P $crossbow_dir ",
#		require	=> File[$crossbow_dir],
#		creates	=> "$crossbow_dir/crossbow-1.2.0.zip"
#		description	=> "downloading the Crossbow"
#	}


	exec {"extract_cloudgene":
		command	=> "/usr/bin/unzip $cloudgene_dir/$cloudgene_archive -d $cloudgene_dir/cloudgene-0.3.0",
		creates => "$cloudgene_dir/cloudgene-0.3.0/",
		require	=> [Package['unzip'], File['serve_cloudgene_archive']]
	}


	file {"serve_cloudgene_archive":
		path	=> "$cloudgene_dir/$cloudgene_archive" ,
		owner		=> "hdfs",
		group		=> "hdfs",
		mode	=> 755,
		source	=> "puppet:///modules/cloudgene/$cloudgene_archive",
		require	=> File["$cloudgene_dir"]
	}

	exec {"make_executable":
		command		=> "/bin/chmod +x $cloudgene_dir/cloudgene-0.3.0/cloudgene",
		require		=> Exec["extract_cloudgene"]
	}
	
	package {"sshfs":
		ensure	=> "installed"
	}

        # link the crossbow to the cloudgene app folder.
	file { '/cloudgene/cloudgene-0.3.0/apps/crossbow':
		ensure  => 'link',
		owner   => "hdfs",
		group   => "supergroup",
#               recurse => "true",
		target  => "/opt/crossbow/crossbow-1.2.0/",
 		require		=> [Exec["extract_cloudgene"]]
# 		require		=> [Exec[crossbow::"extract_crossbow"] ,Exec["extract_cloudgene"]]
       }
}

