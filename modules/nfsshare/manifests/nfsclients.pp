class nfsshare::nfsclients{

	package { "nfs-common":
		ensure => latest
	}

# directory for linking the SSHFS share from /cloudgene/workspace directory
        file {"create_mount_folder":
                path    => "/mnt/homes",
                ensure  => directory,
                owner   => "root",
                group   => "root",
                mode    => 755,
        }
	

	exec {"mount_share":
		command	=>	"/bin/mount master:/mnt/homes /mnt/homes",
		require	=>	Package["nfs-common"]
	}

}
