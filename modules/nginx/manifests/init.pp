class nginx {
  package { "nginx":
    ensure => "present"
  }
  apt::ppa { "ppa:nginx/ppa": }

  package { "nginx":
    ensure => "present",
    require => [ Apt::Ppa['ppa:nginx/ppa'] ]
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

  file { "/etc/nginx/sites-available/${name}":
    content => template("nginx/sites-available/site.erb"),
    require => [ Package['nginx'] ],
    notify => Service['nginx']
  }

  file { "/etc/nginx/sites-enabled/${name}":
    ensure => "/etc/nginx/sites-available/${name}",
    require => File["/etc/nginx/sites-available/${name}"],
    notify => Service['nginx']
  }

  file { "/etc/nginx/sites-available/${name}-secure":
    content => template("nginx/sites-available/secure.erb"),
    require => [ Package['nginx'] ],
    notify => Service['nginx']
  }

  exec { "ln -nfs /etc/nginx/sites-available/${name}-secure /etc/nginx/sites-enabled/${name}-secure":
    require => File["/etc/nginx/sites-available/${name}-secure"],
    onlyif => "test -f /etc/ssl/${name}.crt -a -f /etc/ssl/${name}.key",
    notify => Service['nginx']
  }
}
