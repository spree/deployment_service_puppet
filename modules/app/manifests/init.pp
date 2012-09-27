class app {
  spree::app{$app_name:
    require => User['spree']
  }

  if $deploy_demo {
    spree::demo{'spree':
      require => [ Spree::App['spree'] ]
    }
  }else{
   file{ "/home/spree/demo_version":
     ensure => 'absent'
   }
  }
}
