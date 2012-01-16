class puppetclient{
  include augeas

  service {"puppet":
    ensure => "stopped",
    enable => false,
    require =>[ Augeas['set puppet start default'], Augeas['set puppet pluginsync'] ]
  }

  augeas {"set puppet start default":
    context => "/files/etc/default/puppet",
    changes => "set START no"
  }

  augeas { "set puppet report":
    context => "/files/etc/puppet/puppet.conf/agent",
    changes => "set report true"
  }

  augeas { "set puppet pluginsync":
    context => "/files/etc/puppet/puppet.conf/main",
    changes => "set pluginsync true"
  }

  cron { "run_puppet_run":
    command => "/bin/bash -l -c '/usr/bin/puppet agent --onetime --no-daemonize --logdest console'",
    hour => [7,8,9,10], #times are UTC!
    minute => fqdn_rand(59)
  }
}
