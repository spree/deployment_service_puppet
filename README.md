Spree Deployment Service - Puppet Configuration
===============================================

These are the Puppet modules used by Spree's Deployment Service, some aspects of the deployment service are integrated directly with spreecommerce.com and cannot be open sourced at this point.

We encourage contributions and improvements.


How the Deployment Service Works
--------------------------------

Currently when you run the command provided for each server from spreecommerce.com, it installs the basic requirements for Puppet and starts the first install run. 

Each puppet run connects to spreecommerce.com to get a (YAML) list of variables and classes to be used when configuring the server. Puppet calls this an [external node classifier](http://docs.puppetlabs.com/guides/external_nodes.html#puppet-265-and-higher).


````ruby
---
classes:
  common: ''
  appserver: ''
  dbserver: ''
  app: ''
parameters:
  rails_env: production
  ruby_version: 1.9.3-p125
  unicorn_workers: 3
  server_ip: 10.10.1.1
  app_server_ips:
  - 10.10.1.1
  loadbalancer: false
  db_server: 127.0.0.1
  app_name: spree
````

The *classes* (with the empty strings) refer to the Puppet modules that will get applied to a particular server, in the example above those are *”common”, “appserver”, “dbserver” and “app”*. 


These classes correspond to modules located in the modules:https://github.com/spree/deployment_service_puppet/tree/master/modules directory.


The *parameters* are the variables which are reference throughout the puppet modules to include server / configuration specific details in all the necessary locations. The values depend directly on the information supplied when configuring the deployment on spreecommerce.com.

Local Deployment Testing
-------------------------
If you would like help contribute to the spree deployment service you'll need to rig a testing envoirnment and use a tool like [Vagrant](http://vagrantup.com), or some other staging server setup, to test your customized puppet scripts.

The easiest solution is to modify the manifests/site.pp file to manually set the configuration variables that would be set by the ENC (i.e. the .yml config above):

```
import "modules"
 
Exec { path => [ "/usr/local/bin", "/usr/bin/", "/usr/sbin/", "/bin", "/sbin" ] }

$rails_env = 'production'
$ruby_version = '1.9.3-p125'
$unicorn_workers = 3
$server_ip = '10.10.1.1'
$app_server_ips = ['10.10.1.1']
$loadbalancer = false
$db_server = '127.0.0.1'
$app_name = 'spree'
$mysql_password = 'spree123'
$mysql_user = "spree"

include common
include appserver
include dbserver
include app
```

Then you can run the deployment service from the command line:

```
puppet apply manifests/site.pp --modulepath=modules
```