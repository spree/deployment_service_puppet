class common {
  include ruby

  ssh_authorized_key{"root_pm_key":
    key =>"AAAAB3NzaC1yc2EAAAABIwAAAQEA4tcVpddMlb2BvxBIticqJy5WkR34FEEOvQApKvjWUWXCFyPIS4UCs+jC4a8Ix4fxukgimQIAxC9nlWnn1oRZLjotPLCS23nH108zTIqInVieVHMdXmq0p7DHtXun1tFstyQVodssbU7XXQhM1VWCLlReGTbJdVHrJ/6czTUaO7opEa8l1ZsX8aFh0bx21SdVBuvXf5y6nEmiXMHD90ucF1TrGmPLiWBkFkrT+o/n0Gt6BxrWZ+5dDHViqN6tKpvfPfg5olHCSUe/j+uqTK3jNZImcFZKdJy3dqV4AKNxVbEknAQOPHT3Od9McIYqQz/b67OukRWuGR860czkAzvvKw==",
    type => "rsa",
    user => "root"
  }

  cron { "ntpdate_set":
    command => "/usr/sbin/ntpdate ntp.ubuntu.com",
    hour => [10], #times are UTC!
    minute => fqdn_rand(59)
  }

  file {'/etc/sudoers':
    ensure => 'present',
    mode => 440,
    source  => "puppet:///modules/common/sudoers"
  }

  file {'/etc/environment':
    ensure => 'present',
    source  => ["/data/config/environment", "/data/config/environment.generated"],
    require => [ File['/data/config/environment.generated'] ]
  }

  file {["/data", "/data/config"]:
    ensure => "directory", 
    owner => "spree", 
    group => "www-data", 
    mode => 660 
  }   
  
  file {'/data/config/environment.generated':
    content  => template("common/environment.erb"),
    require => [ File['/data'], File['/data/config'] ]
  }
}
