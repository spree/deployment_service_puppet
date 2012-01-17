#!/usr/bin/ruby
require 'yaml'

fqdn = ARGV[0]
config = {'classes' => {'common' => nil}}
config['parameters'] = {}
config['parameters']['rails_env'] = 'production' 
config['parameters']['ruby_version'] = 'ruby-1.8.7-p352' 
config['parameters']['unicorn_workers'] = '3' 

  config['classes']['appserver'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = 'spree'
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['ruby_version'] = 'ree-1.8.7-2011.03' 

puts YAML.dump(config)



