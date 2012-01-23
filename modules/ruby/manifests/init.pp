class ruby {
  user {'spree':
    ensure => 'present',
    home => '/home/spree',
    shell => '/bin/bash',
    managehome => 'true',
    groups => ['www-data', 'sudo']
  }

 # Not setting Spree password as it should be done manually
 # for more security
 # exec{ "chpasswd-spree":
 #   command => "echo spree:${db_pass} | chpasswd",
 #   subscribe => User['spree'],
 #   refreshonly => true
 # }

  file {'/etc/init':
    ensure => 'directory',
    group => 'spree',
    mode => 775,
    require => User['spree']
  }

  file {"/etc/gemrc":
    ensure => "present",
    source  => "puppet:///modules/common/gemrc"
  }

  case $operatingsystem {
    "Ubuntu", "Debian": {
      package {['imagemagick', 'mysql-client', 'libmysql-ruby', 'libmysqlclient-dev', 'libxml2', 'htop',
               'git-core', 'build-essential', 'libssl-dev', 'libreadline5', 'zlib1g', 
                'zlib1g-dev', 'libxml2-dev', 'libxslt1-dev', 'sqlite3', 'libsqlite3-dev']:
        ensure => 'present'
      }  
    
      case $operatingsystemrelease {
        "6.0.1", "10.04", "11.04": { $libreadline = 'libreadline5-dev' }
        "11.10": { $libreadline = 'libreadline-gplv2-dev' }
      }
    }
  }

  package {'libreadline':
    name => $libreadline,
    ensure => 'present'
  }

  exec { "checkout ruby-build":
    command => "git clone git://github.com/sstephenson/ruby-build.git",
    user    => 'spree',
    group   => 'spree',
    cwd     => "/home/spree",
    creates => "/home/spree/ruby-build",
    path    => ["/usr/bin", "/usr/sbin"],
    logoutput => 'on_failure',
    timeout => 100,
    require => [Package['git-core'], User['spree']]
  }

  exec { "install ruby-build":
    command => "sh install.sh",
    user    => "root",
    group   => "root",
    cwd     => "/home/spree/ruby-build",
    onlyif  => '[ -z "$(which ruby-build)" ]', 
    logoutput => 'on_failure',
    path    => ["/bin", "/usr/local/bin", "/usr/bin", "/usr/sbin"],
    require => Exec['checkout ruby-build'],
  }

  exec { "install ruby":
    command => "ruby-build ${ruby_version} /usr/local",
    user    => "root",
    group   => "root",
    timeout => 0, #disable timeout
    path    => ["/bin", "/usr/local/bin", "/usr/bin", "/usr/sbin"],
    logoutput => 'true', 
    subscribe => File["/home/spree/ruby_version"],
    refreshonly => 'true',
    require => [ Exec['install ruby-build'] ]
  }

  file { "/home/spree/ruby_version":
    ensure  => 'present',
    content => inline_template("<%= ruby_version %>"),
    require => User['spree']
  }

  # force puppet to install gems using
  # ruby-build version and not system ruby
  file { "/usr/bin/gem":
    ensure => "/usr/local/bin/gem",
    require => Exec['install ruby']
  }

  package { ['bundler', 'foreman', 'rake', 'backup']:
    ensure => 'installed',
    provider => 'gem',
    require => File['/usr/bin/gem']
  }

  package { ['net-ssh']:
    ensure => '2.1.4',
    provider => 'gem',
    require => File['/usr/bin/gem']
  }

  package { ['net-scp']:
    ensure => '1.0.4',
    provider => 'gem',
    require => File['/usr/bin/gem']
  }
}
