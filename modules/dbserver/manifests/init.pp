class dbserver {
# only required for 10.04 -- need to drop support for it.
#  include mysql::server
  case $db_server_type {
      'medium': { include mysql::server::medium } 
      'large':  { include mysql::server::large  } 
      'huge':   { include mysql::server::huge  } 
      default:  { include mysql::server::medium } 
  }

  #puppet clients 2.7.14 or later don't need custom augeas lens
  #older versions do, hence this case statement
  case $puppetversion {
    "2.7.14":{
      mysql::config {
        'bind-address':
          value   => $db_server,
          notify => Service["mysql"]
      }
    }
    default: {
      file { "/usr/share/augeas/lenses/contrib/mysql.aug":
        ensure => present,
        source => "puppet:///dbserver/mysql.aug",
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

    }
  }

  case $db_pass {
    "": { $db_pass = "spree123"
      warning("db_pass not set, using default.")
    }
  }

  # nested defines needed to get permissions
  # set correctly for each app and ip pair
  # $app_name is an array, so is $app_server_ips
  #
  define mysql-user(){
    mysql-user-rights{$app_name:
      ip => $name
    } 
  }
  define mysql-user-rights($ip){
	  if $deploy_demo { 
	    mysql::rights{"demo-${name}-rights-${ip}":
	      ensure   => present,
	      database => $name,
	      user     => "spree",
	      host     => $db_server ? {
		'127.0.0.1' => 'localhost',
		default => $name
	      },
	      password => $db_pass,
	      notify   => Exec['reset database for demo'],
	      require  => Mysql::Database["${name}"]
	    }
	  }else{
	    mysql::rights{"${name}-rights-${ip}":
	      ensure   => present,
	      database => $name,
	      user     => "spree",
	      host     => $db_server ? {
		'127.0.0.1' => 'localhost',
		default => $name
	      },
	      password => $db_pass,
	      require  => Mysql::Database["${name}"]
	    }
	  }
  }

  mysql-user{$app_server_ips:}

  mysql::database{$app_name:
    ensure   => present    
  }


  # only spree app can get demo deployed,
  # so the name is hardcoded on purpose
  #
  if $deploy_demo { 
    #gets notified by mysql rights above
    exec { "reset database for demo":
      command => "bundle exec rake db:migrate db:reset AUTO_ACCEPT=true RAILS_ENV=${rails_env}",
      user    => 'spree',
      group   => 'spree',
      cwd     => "/data/spree/current",
      timeout => 1000,
      logoutput => "true",
      subscribe => File["/home/spree/demo_version"],
      require => [ Exec['bundle install demo'], File["/data/spree/shared/config/database.yml"] ],
      refreshonly => true
    }

    exec { "load sample data for demo":
      command => "bundle exec rake spree_sample:load AUTO_ACCEPT=true RAILS_ENV=${rails_env}",
      user    => 'spree',
      group   => 'spree',
      cwd     => "/data/spree/current",
      timeout => 1000,
      logoutput => "true",
      subscribe => Exec["reset database for demo"],
      refreshonly => true
    }
  }

}
