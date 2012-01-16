define backupserver::client::app($client_code){
  file {"/backups/${client_code}/${name}/":
    ensure => directory,
    group => $client_code,
    mode => 770
  }
}
define backupserver::client(){
  user { $name:
    ensure => 'present',
    home => "/home/${name}",
    shell => '/bin/bash',
    managehome => 'true',
    groups => ['backups']
  }

  exec{ "chpasswd-${name}":
    command => "echo ${name}:${$clients[$name]['pass']} | chpasswd",
    subscribe => User[$name],
    refreshonly => true
  }

  file {"/backups/${name}/":
    ensure => directory,
    group => $name,
    mode => 770
  }
  
  backupserver::client::app{ $clients[$name]['apps']:
    client_code => $name
  }

}

class backupserver{
  backupserver::client{ $client_codes: }

  cron { "rotate_backups":
    command => "/bin/bash -l -c '/backups/rotate.rb'",
    hour => [4,16],
    minute => 0
  }

}
