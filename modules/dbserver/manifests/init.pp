class dbserver {
  include mysql

  class { 'mysql::server':
    config_hash => { 'bind_address' => $db_server }
  }

  define create_db(){ 
    if $db_pass == "" {
      $db_pass = "spree123"
    }

    database { $name:
      ensure  => 'present',
      require => [ Class['mysql::server'] ]
    }

    # always allow localhost access
    #
    database_user { "${name}@localhost":
      password_hash => mysql_password($db_pass),
      require => [ Database[$name] ]
    }

    database_grant { "${name}@localhost/${name}":
      privileges => ['all']
    }

    # prepend db name onto each app server ip, to create:
    # db_name@127.0.0.1
    #
    $user_ips = regsubst($app_server_ips, '.*', "${name}@\0")

    database_user { $user_ips:
      password_hash => mysql_password($db_pass),
      require => [ Database[$name] ]
    }

    # prepend AND appends db name onto each app server ip, to create:
    # db_name@127.0.0.1/db_name
    #
    $user_ips_dbs = regsubst($app_server_ips, '.*', "${name}@\0/${name}")

    database_grant { $user_ips_dbs:
      privileges => ['all'] ,
    }
  }

  # using a custom type as app_name maybe an array
  # so we need to create mutliple db's
  # 
  create_db{$app_name:} 

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
      subscribe => [ Database_grant['spree@localhost/spree'], File["/home/spree/demo_version"] ],
      require => [ Create_db['spree'], Exec['bundle install demo'], File["/data/spree/shared/config/database.yml"] ],
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
