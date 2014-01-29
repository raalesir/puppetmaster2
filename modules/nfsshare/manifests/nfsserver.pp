class nfsshare::nfsserver{

	package {"nfs-kernel-server":
		ensure => latest
	}	
	
	package {"portmap":
		ensure => latest
	}	
	
	package { "nfs-common":
		ensure => latest
	}	
	
# directory for linking the SSHFS share from /cloudgene/workspace directory
#	file {"create_mount_folder":
#		path	=> "/mnt/shares",
#		ensure	=> directory,
#		owner	=> "root",
#		group	=> "root",
#		mode	=> 755,
#	}

	file {"create_mount_folder1":
		path	=> "/mnt/homes",
		ensure	=> directory,
		owner	=> "root",
		group	=> "root",
		mode	=> 755,
#		require	=> File["create_mount_folder"]
	}




# add mount to the /etc/exports
	exec {"add_share":
		command	=> "/bin/echo '/mnt/homes slave*.hadoop.vm(ro)' > /etc/exports",
		require	=> File["create_mount_folder1"]
	}

# restart the server
	exec{"restart_the_server":
		command	=> "/usr/sbin/service nfs-kernel-server restart",
		require	=> [Package["nfs-kernel-server"], Exec["add_share"]]
	}
}

