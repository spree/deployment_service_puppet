class dbserver {
  case $db_server_type {
      'medium': { include mysql::server::medium } 
      'large':  { include mysql::server::large  } 
      'huge':   { include mysql::server::huge  } 
      default:  { include mysql::server::medium } 
  }

  augeas { "my.cnf/mysqld-spree":
    context => "${mysql::params::mycnfctx}/mysqld/",
    load_path => "/usr/share/augeas/lenses/contrib/",
    changes => [
     "set bind-address ${db_server}",
    ],
    require => [ File["/etc/mysql/my.cnf"], File["${mysql::params::data_dir}"] ],
    notify => Service["mysql"],
  }

  case $db_pass {
    "": { $db_pass = "spree123"
      warning("db_pass not set, using default.")
    }
  }

  mysql::rights{"${app_name}-rights":
    ensure   => present,
    database => $app_name,
    user     => "spree",
    host     => "%",
    password => $db_pass,
    notify   => Exec['reset database for demo'],
    require  => Mysql::Database["${app_name}"]
  }

  mysql::database{"${app_name}":
    ensure   => present    
  }

  #gets notified by mysql rights above
  exec { "reset database for demo":
    command => "bundle exec rake db:reset AUTO_ACCEPT=true RAILS_ENV=${rails_env}",
    user    => 'spree',
    group   => 'spree',
    cwd     => "/data/spree/current",
    timeout => 100,
    logoutput => "true",
    subscribe => File['/home/spree/demo_version'],
    require => File['/data/spree/shared/config/database.yml'],
    refreshonly => true,
    onlyif => $demo_deploy
  }

  exec { "load sample data for demo":
    command => "bundle exec rake spree_sample:load AUTO_ACCEPT=true RAILS_ENV=${rails_env}",
    user    => 'spree',
    group   => 'spree',
    cwd     => "/data/spree/current",
    timeout => 100,
    logoutput => "true",
    subscribe => Exec["reset database for demo"],
    refreshonly => true
  }

}
