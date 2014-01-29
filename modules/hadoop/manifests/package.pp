class hadoop::package {
  require hadoop::apt #,java
  package { "hadoop":
    ensure => "latest",
  }
}
 
