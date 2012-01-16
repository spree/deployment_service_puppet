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

  include rvm::system

  rvm::system_user { spree:
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

  package {['imagemagick', 'mysql-client', 'libmysql-ruby', 'libmysqlclient-dev', 'libxml2', 'htop']:
    ensure => 'present'
  }
}
