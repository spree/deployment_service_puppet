define spree::app(){
  file {["/data", "/data/${name}", "/data/${name}/releases", "/data/${name}/shared", "/data/${name}/shared/config", "/data/${name}/shared/sockets",
      "/data/${name}/shared/logs", "/data/${name}/shared/pids", "/data/${name}/shared/tmp", "/data/${name}/shared/system"]: 
    ensure => "directory", 
    owner => "spree", 
    group => "www-data", 
    mode => 660 
  }   
}

define spree::site(){
  file { "/data/${name}/shared/config/database.yml":
    content  => template("spree/database.yml.erb"),
    require => File["/data/${name}/shared/config"],
    owner => "spree", 
    group => "www-data", 
    mode => 660 
  }

  file {"/data/${name}/shared/config/unicorn.rb":
    content => template("spree/unicorn.rb.erb"),
    require => File["/data/${name}/shared/config"],
    owner => "spree",
    group => "www-data",
    mode => 660
  }

  file {"/data/${name}/shared/config/Procfile":
    content => template("spree/Procfile.erb"),
    require => File["/data/${name}/shared/config"],
    owner => "spree",
    group => "www-data",
    mode => 660
  }
}
