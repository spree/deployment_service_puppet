class app {
  spree::app{"$app_name":
    require => User['spree']
  }

  if $deploy_demo {
    spree::demo{"$app_name":
      require => [ Spree::App["${app_name}"] ]
    }
  }else{
   file{ "/home/spree/demo_version":
     ensure => 'absent'
   }
  }
}
