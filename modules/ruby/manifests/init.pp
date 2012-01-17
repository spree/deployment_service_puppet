class ruby {
  user {'spree':
    ensure => 'present',
    home => '/home/spree',
    shell => '/bin/bash',
    managehome => 'true',
    groups => ['www-data', 'sudo']
  }

  file {'/etc/init':
    group => 'spree',
    mode => 775,
    require => User['spree']
  }

  spree::app{"$app_name":
    require => User['spree']
  }

  file {"/etc/gemrc":
    ensure => "present",
    source  => "puppet:///modules/common/gemrc"
  }

  if $rvm_installed == "true" {
    rvm_system_ruby {$ruby_version:
      ensure => 'present',
      default_use => true
    }

    rvm_gem {"${ruby_version}/bundler":
        ensure => 'present',
        require => Rvm_system_ruby[$ruby_version]
    }

    rvm_gem {"${ruby_version}/rake":
        ensure => 'present',
        require => Rvm_system_ruby[$ruby_version]
    }

    rvm_gem {"${ruby_version}/net-ssh":
        ensure => '2.1.4',
        require => Rvm_system_ruby[$ruby_version]
    }

    rvm_gem {"${ruby_version}/net-scp":
        ensure => '1.0.4',
        require => Rvm_system_ruby[$ruby_version]
    }

    rvm_gem {"${ruby_version}/backup":
        ensure => 'present',
        require => Rvm_system_ruby[$ruby_version]
    }

  } 

  package {['imagemagick', 'mysql-client', 'libmysql-ruby', 'libmysqlclient-dev', 'libxml2', 'htop',
            'git-core', 'build-essential', 'libssl-dev', 'libreadline5', 'libreadline5-dev', 'zlib1g', 'zlib1g-dev']:
    ensure => 'present'
  }

  exec { "checkout ruby-build":
    command => "git clone git://github.com/sstephenson/ruby-build.git",
    user    => 'spree',
    group   => 'spree',
    cwd     => "/home/spree",
    creates => "/home/spree/ruby-build",
    path    => ["/usr/bin", "/usr/sbin"],
    timeout => 100,
    require => [Package['git-core'], User['spree']]
  }

  exec { "install ruby-build":
    command => "sh install.sh",
    user    => "root",
    group   => "root",
    cwd     => "/home/spree/ruby-build",
    onlyif  => '[ -z "$(which ruby-build)" ]', 
    path    => ["/bin", "/usr/local/bin", "/usr/bin", "/usr/sbin"],
    require => Exec['checkout ruby-build'],
  }

  file {'/usr/rubies':
    ensure => 'directory',
    mode   => 775,
  }

  exec { "install ruby":
    command => "ruby-build 1.9.3-p0 /usr/local",
    user    => "root",
    group   => "root",
    creates => "/usr/local/bin/ruby",
    timeout => 0, #disable timeout
    path    => ["/bin", "/usr/local/bin", "/usr/bin", "/usr/sbin"],
    require => [ Exec['install ruby-build'], File['/usr/rubies'] ]
  }

}
