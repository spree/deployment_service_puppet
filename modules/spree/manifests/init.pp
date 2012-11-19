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

  file {"/data/${name}/shared/config/master.pill.erb":
    source  => "puppet:///modules/spree/bluepill_master.pill.erb",
    require => File["/data/${name}/shared/config"],
    owner => "spree",
    group => "www-data",
    mode => 660
  }

  file {"/data/${name}/shared/config/${name}.pill":
    content => template("spree/placeholder.pill.erb"),
    require => File["/data/${name}/shared/config"],
    owner => "spree",
    group => "www-data",
    mode => 660,
    replace => false
  }
}


# demo is only every defined for the 'spree' application
# so we don't refer to the $app_name variable
#
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
    command => "bundle exec foreman export bluepill /data/spree/shared/config/ --template=/data/spree/shared/config/",
    creates => '/data/spree/shared/config/spree.pill',
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
#    notify    => [Exec["restart spree"], Exec["start spree"] ],
    require   => [ Exec["bundle install demo"], File["/data/${name}/current/config/database.yml"] ]
  }


}
