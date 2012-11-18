class dbserver {
  class { 'mysql::server':
    config_hash => { 'root_password' => 'foo' }
  }

  mysql::server::config { 'testfile':
    settings => {
      'mysqld' => {
        'bind-address' => db_server,
      }
    }
  }

  case $db_pass {
    "": { $db_pass = "spree123"
      warning("db_pass not set, using default.")
    }
  }

  define db-for-app(){
    mysql::db { "${name}":
      user     => $name,
      password => $db_pass,
      host     => $app_server_ips,
    }
  }

  db-for-app($app_name:)

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
