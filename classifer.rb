#!/usr/bin/ruby
require 'yaml'

clients = {
  'w2w'   => { 'pass' => '1ujFHwUfx85D', 'apps' => ['wall2wall'] },
  'fpc'   => { 'pass' => 'XrL6RtwTZtCD', 'apps' => ['thefitpc'] },
  'blb'   => { 'pass' => '6Ak4xLJQ20Vt', 'apps' => ['bricklanebikes'] },
  'sol'   => { 'pass' => 'CJ5DymkoyYbN', 'apps' => ['solitude'] },
  'rdr'   => { 'pass' => 'C7h6u3iVNe4X', 'apps' => ['demo'] },
  'spr'   => { 'pass' => 'YTkNRpO4RsGW', 'apps' => ['website'] },
  'spra'  => { 'pass' => 'fS9OCxUY1r0b', 'apps' => ['alerts'] },
  'ndsf'  => { 'pass' => 'Xqe7oBCw0j4g', 'apps' => ['stores'] },
  'ndsf1' => { 'pass' => 'ilHQu5RBwSXn', 'apps' => ['signup'] },
  'swp'   => { 'pass' => 'VGNez7umn8Bm', 'apps' => ['swervepoint'] },
  'illf'  => { 'pass' => 'eBeVw7NxZaS6', 'apps' => ['illf'] },
  'pup'   => { 'pass' => 'AO4l2kIRg4qI', 'apps' => ['puppetdash'] },
  'mri'   => { 'pass' => '83LuFLqXE4qd', 'apps' => ['mercerie'] },
  'mod'   => { 'pass' => 'jSY0ErEBfs4B', 'apps' => ['mode'] },
  'mod1'  => { 'pass' => '4eIe8Cg2OfCj', 'apps' => ['mode-stg'] },
  'mul1'  => { 'pass' => '1bgZjy87PlM0', 'apps' => ['multispree1'] },
  'mul2'  => { 'pass' => '1bgZjy87PlM0', 'apps' => ['multispree2'] },
  'jd1'   => { 'pass' => '1bgZjy87PlM0', 'apps' => ['johnd'] },
  'gw1'   => { 'pass' => '1bgZjy87PlM0', 'apps' => ['skrill_demo'] },
  'gw2'   => { 'pass' => '1bgZjy87PlM0', 'apps' => ['usa_epay_demo'] },
  'cmyk'  => { 'pass' => 'b6ruWNPaLiYR', 'apps' => ['cmyk_proof'] },
  'pero'  => { 'pass' => 'iHrSeH5StKsO', 'apps' => ['proflyshop'] },
  'stm'   => { 'pass' => 'UYF9mSrYMQh3', 'apps' => ['stickermule'] },
  'stm1'  => { 'pass' => 'OzfkcgaAGFE5', 'apps' => ['sticker-staging'] },
  'spx'   => { 'pass' => 'nKjZ9N0vI0ji', 'apps' => ['spex'] },
  'tfh'   => { 'pass' => 'tRMCMvl6uvop', 'apps' => ['tfh_webstore'] },
  'sty'   => { 'pass' => '7bJ2zoRcaSou', 'apps' => ['styxryvr'] },
  'tor'   => { 'pass' => 'jaQTCh9n4VoN', 'apps' => ['tortus'] },
  'amb'   => { 'pass' => 'kh7DBQNqH9AU', 'apps' => ['shop'] },
  'heg'   => { 'pass' => 'TQO65hNC2XkT', 'apps' => ['hegemon'] },
  'cfs'   => { 'pass' => 'X6wDmnkugA3y', 'apps' => ['childsfarm'] },
  'wula'  => { 'pass' => '69MdjSBbu5UO', 'apps' => ['wuladrum'] },
  'hol'   => { 'pass' => 'u5dq6gPMCqR8', 'apps' => ['holiday'] },
  'scf'   => { 'pass' => 'aaNpw18kZegS', 'apps' => ['scframes'] },
  'flr'   => { 'pass' => 'kQ1cMfMK5GPA', 'apps' => ['floriestyle'] }
}

fqdn = ARGV[0]
config = {'classes' => {'common' => nil}}
config['parameters'] = {}
config['parameters']['rails_env'] = 'production' 
config['parameters']['ruby_version'] = 'ruby-1.8.7-p352' 
config['parameters']['unicorn_workers'] = '3' 

if %w{app1.wall2wallstickers.com}.include? fqdn
  client_code = 'w2w'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '10.182.164.130'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %{db1.wall2wallstickers.com}.include? fqdn
  client_code = 'w2w'

  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first
  config['parameters']['db_server'] = '10.182.164.130'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %w{app1.spexonthebeach.com}.include? fqdn
  client_code = 'spx'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '10.181.53.176'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %w{app2.spexonthebeach.com}.include? fqdn
  client_code = 'spx'

  config['classes']['appserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '10.181.53.176'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %{db1.spexonthebeach.com}.include? fqdn
  client_code = 'spx'

  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first
  config['parameters']['db_server'] = '10.181.53.176'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %w{stg1.stickermule.com}.include? fqdn
  client_code = 'stm1'

  config['classes']['appserver'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['rails_env'] = 'staging' 
  config['parameters']['unicorn_workers'] = '2' 
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ree-1.8.7-2011.03' 

elsif %w{app1.stickermule.com}.include? fqdn
  client_code = 'stm'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '10.181.53.242'
  config['parameters']['unicorn_workers'] = '3' 
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ree-1.8.7-2011.03' 

elsif %w{app2.stickermule.com}.include? fqdn
  client_code = 'stm'

  config['classes']['appserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '10.181.53.242'
  config['parameters']['unicorn_workers'] = '3' 
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ree-1.8.7-2011.03' 

elsif %w{app3.stickermule.com}.include? fqdn
  client_code = 'stm'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '10.181.53.242'
  config['parameters']['unicorn_workers'] = '5' 
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ree-1.8.7-2011.03' 

elsif %{db1.stickermule.com}.include? fqdn
  client_code = 'stm'

  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first
  config['parameters']['db_server'] = '10.181.53.242'
  config['parameters']['db_server_type'] = 'huge'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ree-1.8.7-2011.03' 

elsif %w{app1.proofnewyork.com}.include? fqdn
  client_code = 'cmyk'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '10.182.164.88'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %{db1.proofnewyork.com}.include? fqdn
  client_code = 'cmyk'

  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first
  config['parameters']['db_server'] = '10.182.164.88'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %w{app1.wuladrum.com}.include? fqdn
  client_code = 'wula'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ree-1.8.7-2011.03' 

elsif %w{app1.floriestyle.com}.include? fqdn
  client_code = 'flr'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ree-1.8.7-2011.03' 

elsif %w{app1.thefitpc.com}.include? fqdn
  client_code = 'fpc'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ree-1.8.7-2011.03' 

elsif %w{app1.scframes.com}.include? fqdn
  client_code = 'scf'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ruby-1.9.3-p0' 

elsif %w{skrill.spreeworks.com}.include? fqdn
  client_code = 'gw1'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ruby-1.9.2-p290' 

elsif %w{usa-epay.spreeworks.com}.include? fqdn
  client_code = 'gw2'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %w{app1.tfh.org}.include? fqdn
  client_code = 'tfh'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ree-1.8.7-2011.03'

elsif %w{app1.solitudestudio.net}.include? fqdn
  client_code = 'sol'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ruby-1.9.2-p290'

elsif %w{app1.childsfarmshop.com}.include? fqdn
  client_code = 'cfs'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ruby-1.9.2-p290'

elsif %w{app1.hegemonstore.com}.include? fqdn
  client_code = 'heg'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ruby-1.9.2-p290'

elsif %w{app1.bricklanebikes.com}.include? fqdn
  client_code = 'blb'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ree-1.8.7-2011.03'

elsif %w{app1.styxryvr.com}.include? fqdn
  client_code = 'sty'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ree-1.8.7-2011.03'

elsif %w{app1.nationalbuylocal.com}.include? fqdn
  client_code = 'tor'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['ruby_version'] = 'ruby-1.9.2-p290'
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %w{app1.ambertraders.com}.include? fqdn
  client_code = 'amb'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %w{app1.modeflowers.com}.include? fqdn
  client_code = 'mod'

  config['classes']['appserver'] = nil
  config['classes']['dbserver'] = nil
  config['classes']['backup'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ruby-1.8.7-p174' 

elsif %w{db1.modeflowers.com}.include? fqdn
  client_code = 'mod'

  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %w{stg1.modeflowers.com}.include? fqdn
  client_code = 'mod1'

  config['classes']['appserver'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %w{app1.pero-ict.nl}.include? fqdn
  client_code = 'pero'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ruby-1.9.2-p290'

elsif %w{alerts.spreecommerce.com}.include? fqdn
  client_code = 'spra'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %w{app1.mercerie.com}.include? fqdn
  client_code = 'mri'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %w{db1.spreeworks.com}.include? fqdn
  client_code = 'mul1'

  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first
  config['parameters']['db_server'] = '10.180.47.93'
  config['parameters']['db_server_type'] = 'medium'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ree-1.8.7-2011.03'

elsif %w{app1.spreeworks.com}.include? fqdn
  client_code = 'mul1'

  config['classes']['appserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first
  config['parameters']['db_server'] = '10.180.47.93'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['unicorn_workers'] = '5' 
  config['parameters']['ruby_version'] = 'ree-1.8.7-2011.03'

elsif %w{johnd.spreeworksdemo.com}.include? fqdn
  client_code = 'jd1'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ree-1.8.7-2011.03'

elsif %w{demo.spreeworks.com}.include? fqdn
  client_code = 'mul2'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']
  config['parameters']['ruby_version'] = 'ree-1.8.7-2011.03' 

elsif %w{app1.sporttourshop.com}.include? fqdn
  client_code = 'sts'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %w{app1.ilovelondonflowers.co.uk}.include? fqdn
  client_code = 'illf'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first 
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %w{app1.demo.spreecommerce.com}.include? fqdn
  client_code = 'rdr'

  config['classes']['appserver'] = nil
  config['classes']['backup'] = nil
  config['parameters']['client_code'] = client_code
  config['parameters']['app_name'] = clients[client_code]['apps'].first
  config['parameters']['db_server'] = '50.56.104.24'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %w{app1.spreecommerce.com}.include? fqdn
  client_code = 'spr'

  config['classes']['appserver'] = nil
  config['classes']['dbserver'] = nil
  config['classes']['backup'] = nil
  config['parameters']['ruby_version'] = 'ruby-1.9.2-p290'
  config['parameters']['client_code'] = client_code
  config['parameters']['app_name'] = clients[client_code]['apps'].first
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %{db1.demo.spreecommerce.com}.include? fqdn
  client_code = 'rdr'

  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first
  config['parameters']['db_server'] = '50.56.104.24'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %w{app1.swervepoint.com}.include? fqdn
  client_code = 'swp'

  config['classes']['appserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first
  config['parameters']['db_server'] = '50.57.41.175'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %{db1.swervepoint.com}.include? fqdn
  client_code = 'swp'

  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first
  config['parameters']['db_server'] = '50.57.41.175'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %w{app1.ndstorefront.com}.include? fqdn
  client_code = 'ndsf'

  config['classes']['appserver'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = client_code
  config['parameters']['db_pass'] = clients[client_code]['pass']

elsif %w{app1.signup.ndstorefront.com}.include? fqdn
  client_code = 'ndsf1'

  config['classes']['appserver'] = nil
  config['classes']['dbserver'] = nil
  config['parameters']['app_name'] = clients[client_code]['apps'].first
  config['parameters']['db_server'] = '127.0.0.1'
elsif "backup1.spreeworks.com" == fqdn
  config['classes']['backupserver'] = nil
  config['parameters']['app_name'] = 'dummy'
  config['parameters']['db_server'] = '127.0.0.1'
  config['parameters']['client_code'] = 'dummy'
  config['parameters']['db_pass'] = 'dummy'
  config['parameters']['client_codes'] = clients.keys
  config['parameters']['clients'] = clients
end

puts YAML.dump(config)


