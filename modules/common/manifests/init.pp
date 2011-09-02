class common {
  include augeas

  service {"puppet":
    ensure => "running",
    enable => true,
    require =>[ Augeas['set puppet start default'], Augeas['set puppet pluginsync'] ]
  }
  
  augeas {"set puppet start default":
    context => "/files/etc/default/puppet",
    changes => "set START yes",
    notify => Service['puppet']
  }

  augeas { "set puppet pluginsync":
    context => "/files/etc/puppet/puppet.conf/main",
    changes => "set pluginsync true",
    notify => Service['puppet']
  }

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
      'ruby-1.8.7/bundler':
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
