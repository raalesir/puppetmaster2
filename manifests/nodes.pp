node /slave\d+/ {
#node slave {
	include hadoop::datanode
	include hadoop::tasktracker
#	include nfsshare::nfsclients
}

node master {
	include hadoop::namenode
	include hadoop::jobtracker
#	include nfsshare::nfsserver
}

#node client {
#	include hadoop::client
#}
