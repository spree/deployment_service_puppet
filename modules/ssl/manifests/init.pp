class ssl {
  #this class can be removed once all nodes have updated.
  #ssl is being handled by the nginx class now.

  file {"/data/ssl/spreeworks_combined.crt":
    ensure => absent
  }

  file {"/etc/ssl/spreeworks_combined.crt":
    ensure => absent
  }

  file {"/data/ssl/star_spreeworks_com.key":
    ensure => absent
  }
 
  file {"/etc/ssl/star_spreeworks_com.key":
    ensure => absent
  }
}
