class ssl {
  file {"/etc/ssl/spreeworks_combined.crt":
    source => "puppet:///files/spreeworks_combined.crt"
  }
 
  file {"/etc/ssl/star_spreeworks_com.key":
    source => "puppet:///files/star_spreeworks_com.key"
  }
}
