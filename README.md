Spree Deployment Service - Puppet Configuration
===============================================

These are the Puppet modules used by Spree's Deployment Service, some aspects of the deployment service are integrated directly with spreecommerce.com and cannot be open sourced at this point.

We encourage contributions and improvements.


How the deployment service works
--------------------------------

Currently when you run the command provided for each server from spreecommerce.com, it installs the basic requirements for Puppet and starts the first install run. 

Each puppet run connects to spreecommerce.com to get a (YAML) list of variables and classes to be used when configuring the server.


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
