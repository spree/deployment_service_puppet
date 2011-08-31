class appserver {
  file { '/data':
    ensure => 'present',
    mode => 660,
    owner => 'spree',
    group => 'www-data'
  }
}
