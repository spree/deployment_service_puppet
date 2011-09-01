class common {
  include augeas

  user {'spree':
    ensure => 'present',
    home => '/home/spree',
    shell => '/bin/bash',
    managehome => 'true',
    groups => ['www-data', 'sudo']
  }
 
  file {'/etc/init':
    group => 'spree',
    mode => 755,
    require => User['spree']
  }

  file {'/etc/environment':
    ensure => 'present',
    content => template('common/etc/environment')
  }
 
  spree::app{"$app_name":
    require => User['spree']
  }

  include rvm::system
  rvm::system_user { spree:
    require => User['spree']
  }

  file {"/etc/gemrc":
    ensure => "present",
    source  => "puppet:///modules/common/gemrc"
  }

  if $rvm_installed == "true" {
    rvm_system_ruby {'ruby-1.8.7-p352':
      ensure => 'present',
      default_use => true
    }
	
    rvm_gem {
      'ruby-1.8.7@/bundler':
        ensure => 'present',
        require => Rvm_system_ruby['ruby-1.8.7-p352']
    }

    rvm_gem {
      'ruby-1.8.7/rake':
        ensure => 'present',
        require => Rvm_system_ruby['ruby-1.8.7-p352']
    }
  } 

  package {['imagemagick', 'mysql-client', 'libmysql-ruby', 'libmysqlclient-dev', 'libxml2']:
    ensure => 'present'
  }
}
