class backup{
  
  file { "/data/config/daily_backup.rb":
    content => template("backup/daily_backup.rb.erb"),
    mode    => 770,
    group   => 'spree',
    require => File['/data/config']
  }

  cron { "daily_backup":
    command => "/bin/bash -l -c 'backup perform -t today --config-file /data/config/daily_backup.rb'",
    hour => [2,14],
    minute => fqdn_rand(59),
    require => File["/data/config/daily_backup.rb"]
  }

}
