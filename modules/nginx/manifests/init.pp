class nginx {
  include ssl

  package { "nginx":
    ensure => "present"
  }
  
  service { "nginx":
    ensure => "running",
    enable => true,
    require => Package['nginx']
  } 

  file { "/etc/nginx/nginx.conf":
    content => template("nginx/nginx.conf.erb"),
    require => Package['nginx'],
    notify => Service['nginx']
  }

  file {"/etc/nginx/sites-enabled/default":
    ensure => "absent",
    notify => Service['nginx']
  }
}

define nginx::site {
  file { "/etc/nginx/sites-available/${name}":
    content => template("nginx/sites-available/site.erb"),
    require => Package['nginx']
  }
  
  exec { "ln -nfs /etc/nginx/sites-available/${name} /etc/nginx/sites-enabled/${name}":
    creates => "/etc/nginx/sites-enabled/${name}",
    require => File["/etc/nginx/sites-available/${name}"],
    notify => Service['nginx']
  }
}
