/*
== Class: mysql::slave::common
** The composants available in all versions of MySQL
** This is the inital mysql::slave class.
*/
class mysql::slave::common inherits mysql::master {

  augeas { "my.cnf/slave-replication":
    context => "${mysql::params::mycnfctx}/mysqld/",
    load_path => "/usr/share/augeas/lenses/contrib/",
    changes => [
      "set relay-log /var/lib/mysql/mysql-relay-bin",
      "set relay-log-index /var/lib/mysql/mysql-relay-bin.index",
      "set relay-log-info-file /var/lib/mysql/relay-log.info",
      "set relay_log_space_limit 2048M",
      "set max_relay_log_size 100M",
      "set master-host ${mysql_masterhost}",
      "set master-user ${mysql_masteruser}",
      "set master-password ${mysql_masterpw}",
      "set report-host ${hostname}"
    ],
  }

}
