class dbserver {
  include mysql::server

  augeas { "my.cnf/mysqld-spree":
  context => "${mysql::params::mycnfctx}/mysqld/",
    load_path => "/usr/share/augeas/lenses/contrib/",
    changes => [
     "set bind-address ${db_server}",
    ],
    require => [ File["/etc/mysql/my.cnf"], File["${mysql::params::data_dir}"] ],
    notify => Service["mysql"],
  }

  mysql::rights{"${app_name}-rights":
    ensure   => present,
    database => $app_name,
    user     => "spree",
    host     => "%",
    password => $db_pass
  }

  mysql::database{"${app_name}":
    ensure   => present
  }



}
