define spree::app(){
  case $db_pass {
    "": { $db_pass = "spree123"
      warning("db_pass not set, using default.")
    }
  }

  file {["/data/${name}", "/data/${name}/releases", "/data/${name}/shared", "/data/${name}/shared/sockets", "/data/${name}/shared/config",
      "/data/${name}/shared/log", "/data/${name}/shared/pids", "/data/${name}/shared/tmp", "/data/${name}/shared/system"]:
    ensure => "directory", 
    owner => "spree", 
    group => "www-data", 
    mode => 660, 
    require => [ File['/data'] ]
  }   

  file { "/data/${name}/shared/config/database.yml":
    content  => template("spree/database.yml.erb"),
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

  file {"/data/${name}/shared/config/.foreman":
    content => template("spree/dot-foreman.erb"),
    require => File["/data/${name}/shared/config"],
    owner => "spree",
    group => "www-data",
    mode => 660
  }
}

define spree::demo(){

  file { "/home/spree/demo_version":
    ensure  => 'present',
    content => inline_template("<%= spree_git_url %>"),
    require => User['spree']
  }

  exec { "checkout spree-demo":
    command => "rm -rf demo; git clone ${spree_git_url} demo",
    user    => 'spree',
    group   => 'spree',
    cwd     => "/data/spree/releases",
    timeout => 500,
    logoutput => 'on_failure',
    subscribe => File['/home/spree/demo_version'],
    creates => '/data/spree/releases/demo',
    require => [ Package['git-core'], User['spree'] ] 
  }

  file { "/data/spree/current":
    ensure => "/data/spree/releases/demo",
    require => [Exec['checkout spree-demo']]
  }   

  file { "/data/${name}/current/config/database.yml":
    ensure => "/data/${name}/shared/config/database.yml",
    owner => "spree", 
    group => "www-data", 
    mode => 660,
    require => [Exec['checkout spree-demo']]
  }

  file { "/data/spree/current/Procfile":
    ensure => "/data/spree/shared/config/Procfile",
    require => [Exec['checkout spree-demo']]
  }   

  file { "/data/spree/current/.foreman":
    ensure => "/data/spree/shared/config/.foreman",
    require => [Exec['checkout spree-demo']]
  }   

  exec { "bundle install demo":
    command  => "bundle install --gemfile /data/spree/releases/demo/Gemfile --path /data/spree/shared/bundle --deployment --without development test",
    user      => 'spree',
    group     => 'spree',
    cwd       => "/data/spree/releases/demo",
    logoutput => 'on_failure',
    timeout   => 3000,
    subscribe => Exec['checkout spree-demo'],
    refreshonly => true,
    require   => [Exec['checkout spree-demo'], File["/data/${name}/current/config/database.yml"] ]
  }

  exec { "foreman export demo":
    command => "bundle exec foreman export upstart /etc/init",
    creates => '/etc/init/spree.conf',
    user => 'spree',
    group => 'spree',
    cwd => "/data/spree/releases/demo",
    logoutput => 'on_failure',
    timeout => 300,
    require => [ File["/data/spree"], File["/data/spree/current/.foreman"], File["/data/spree/current/Procfile"], Exec["bundle install demo"] ]
  }

  exec { "precompile assets for demo":
    command   => "bundle exec rake assets:precompile",
    user      => 'spree',
    group     => 'spree',
    cwd       => "/data/spree/releases/demo",
    logoutput => 'true',
    timeout   => 1000,
    onlyif    => "/bin/sh -c 'bundle exec rake db:version --trace RAILS_ENV=${rails_env} | grep \"Current version: [0-9]\{5,\}\"'",
    creates   => "/data/spree/releases/demo/public/assets",
    notify    => [Exec["restart spree"], Exec["start spree"] ],
    require   => [ Exec["bundle install demo"], File["/data/${name}/current/config/database.yml"] ]
  }

  exec { "restart spree":
    command   => "/bin/sh -c 'restart spree'",
    user      => 'root',
    group     => 'root',
    cwd       => "/data/spree/releases/demo",
    logoutput => 'true',
    timeout   => 1000,
    refreshonly => true,
    require => [ Exec['foreman export demo'] ]
  }

  #service { "spree":
  #  provider => 'upstart',
  #  ensure => 'running',
  #  require => [Exec['foreman export demo'] ]
  #}

# exec below only required while service above is not working
# due to client 2.7.14 problems

  exec { "start spree":
    command   => "/bin/sh -c 'start spree'",
    user      => 'root',
    group     => 'root',
    cwd       => "/data/spree/releases/demo",
    logoutput => 'true',
    timeout   => 1000,
    require => [ Exec['foreman export demo'] ]
  }
}
