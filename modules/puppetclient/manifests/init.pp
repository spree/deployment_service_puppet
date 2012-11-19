class puppetclient{

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
}
