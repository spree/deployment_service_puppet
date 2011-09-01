#!/usr/bin/ruby
require 'yaml'

fqdn = ARGV[0]
config = {'classes' => {'common' => nil}}
config['parameters'] = {}

if %w{app1.wall2wallstickers.com}.include? fqdn
  config['classes']['appserver'] = nil
  config['parameters']['app_name'] = 'wall2wall'
  config['parameters']['db_server'] = '50.57.44.113'
  config['parameters']['db_pass'] = '1ujFHwUfx85D'

elsif %w{app1.thefitpc.com}.include? fqdn
  config['classes']['appserver'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = 'thefitpc'
  config['parameters']['db_pass'] = 'XrL6RtwTZtCD'

elsif %{db1.wall2wallstickers.com}.include? fqdn
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = 'wall2wall'
  config['parameters']['db_server'] = '50.57.44.113'
  config['parameters']['db_pass'] = '1ujFHwUfx85D'

end

puts YAML.dump(config)
