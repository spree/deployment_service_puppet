class nginx {
#  include ssl

  package { "nginx":
    ensure => "present"
  }
  
  service { "nginx":
    ensure => "running",
    enable => true,
    require => [Package['nginx'], File['/etc/nginx/nginx.conf'] ]
  } 

  file { "/etc/nginx/nginx.conf":
    content => ["/data/config/nginx/nginx.conf", template("nginx/nginx.conf.erb")],
    require => Package['nginx'],
    notify => Service['nginx']
  }

  file {"/etc/nginx/sites-enabled/default":
    ensure => "absent",
    notify => Service['nginx']
  }
}

define nginx::site {

  #file {"/etc/ssl/${name}.crt":
  #  source => ["/data/config/ssl/${name}.crt", "/data/ssl/${name}.crt", "puppet:///files/spreeworks_combined.crt"],
  #  notify => Service['nginx']
  #}

  #file {"/etc/ssl/${name}.key":
  #  source => ["/data/config/ssl/${name}.key", "/data/ssl/${name}.key", "puppet:///files/star_spreeworks_com.key"],
  #  notify => Service['nginx']
  #}

  # uses generated file from below, or overriden version
  #
  file { "/etc/nginx/sites-available/${name}":
    content => template("nginx/sites-available/site.erb"),
    require => [ Package['nginx'] ],# File["/data/config/nginx/${name}.generated"], File["/etc/ssl/${name}.crt"], File["/etc/ssl/${name}.key"] ],
    notify => Service['nginx']
  }

  exec { "ln -nfs /etc/nginx/sites-available/${name} /etc/nginx/sites-enabled/${name}":
    creates => "/etc/nginx/sites-enabled/${name}",
    require => File["/etc/nginx/sites-available/${name}"],
    notify => Service['nginx']
  }
}
