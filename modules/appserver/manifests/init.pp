class appserver {
  include nginx
  
  spree::site{"$app_name":}
  nginx::site{"$app_name":}
}
