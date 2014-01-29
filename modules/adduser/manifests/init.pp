class adduser{

	$cloudgeneUser = "raalesir"
	$cloudgeneGroup = "2013023"

        #group { $cloudgeneUser:
        #       ensure => "present",
        #}

	#user { "$cloudgeneUser": 
	#	ensure          => "present",
	#	gid             => "$cloudgenUser",
	#}
        
	$d='/cloudgene'
	
	file { [ "$d/bob" ]:
		ensure  => directory,
		group   => hdfs,
		owner   => hdfs,
		recurse => true,
		mode    => 700  
        }       

}
