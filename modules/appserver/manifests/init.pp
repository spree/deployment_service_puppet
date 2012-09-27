class appserver {
  include nginx

  nginx::site{"$app_name":}

  file {"/data/${app_name}/shared/config/unicorn.rb":
    content => template("appserver/unicorn.rb.erb"),
    require => File["/data/${app_name}/shared/config"],
    owner => "spree",
    group => "www-data",
    mode => 660
  }

}
