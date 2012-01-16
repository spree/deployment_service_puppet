class ruby {
  ssh_authorized_key{"spree_pm_key":
    key =>"AAAAB3NzaC1yc2EAAAABIwAAAQEA4tcVpddMlb2BvxBIticqJy5WkR34FEEOvQApKvjWUWXCFyPIS4UCs+jC4a8Ix4fxukgimQIAxC9nlWnn1oRZLjotPLCS23nH108zTIqInVieVHMdXmq0p7DHtXun1tFstyQVodssbU7XXQhM1VWCLlReGTbJdVHrJ/6czTUaO7opEa8l1ZsX8aFh0bx21SdVBuvXf5y6nEmiXMHD90ucF1TrGmPLiWBkFkrT+o/n0Gt6BxrWZ+5dDHViqN6tKpvfPfg5olHCSUe/j+uqTK3jNZImcFZKdJy3dqV4AKNxVbEknAQOPHT3Od9McIYqQz/b67OukRWuGR860czkAzvvKw==",
    type => "rsa",
    user => "spree"
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
