import "modules"
 
Exec { path => [ "/usr/local/bin", "/usr/bin/", "/usr/sbin/", "/bin", "/sbin" ] }

node default {
  include puppetclient
}
