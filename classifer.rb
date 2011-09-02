#!/usr/bin/ruby
require 'yaml'

fqdn = ARGV[0]
config = {'classes' => {'common' => nil}}
config['parameters'] = {}

if %w{app1.wall2wallstickers.com}.include? fqdn
  config['classes']['appserver'] = nil
  config['parameters']['app_name'] = 'wall2wall'
  config['parameters']['db_server'] = '10.182.164.130'
  config['parameters']['db_pass'] = '1ujFHwUfx85D'

elsif %w{app1.thefitpc.com}.include? fqdn
  config['classes']['appserver'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = 'thefitpc'
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['db_pass'] = 'XrL6RtwTZtCD'

elsif %{db1.wall2wallstickers.com}.include? fqdn
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = 'wall2wall'
  config['parameters']['db_server'] = '10.182.164.130'
  config['parameters']['db_pass'] = '1ujFHwUfx85D'

elsif %{app1.skateshop.com.au app2.skateshop.com.au}.include? fqdn
  config['classes']['appserver'] = nil
  config['parameters']['app_name'] = 'skateshop'
  config['parameters']['db_server'] = '50.57.126.158'
  config['parameters']['db_pass'] = 'OJxfiAu024Sm'

elsif %{db1.skateshop.com.au}.include? fqdn
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = 'skateshop'
  config['parameters']['db_server'] = '50.57.126.158'
  config['parameters']['db_pass'] = 'OJxfiAu024Sm'

end

puts YAML.dump(config)
