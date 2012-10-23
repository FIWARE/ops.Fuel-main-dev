node default {

  Exec  {path => '/usr/bin:/bin:/usr/sbin:/sbin'}

  # $centos_repos =
  # [
  #  {
  #  "name" => "Puppet",
  #  "url"  => "http://yum.puppetlabs.com/el/6/products/x86_64"
  #  },
  #  {
  #  "name" => "Stanford",
  #  "url"  => "http://mirror.stanford.edu/yum/pub/centos/6.3/os/x86_64"
  #  },
  #  ]
 
  $centos_iso = "file:///var/www/nailgun/iso/CentOS-6.3-x86_64-minimal.iso"
  $cobbler_user = "cobbler"
  $cobbler_password = "cobbler"

  $mco_pskey = "un0aez2ei9eiGaequaey4loocohjuch4Ievu3shaeweeg5Uthi"
  $mco_stompuser = "mcollective"
  $mso_stomppassword = "AeN5mi5thahz2Aiveexo"
  
  $pip_repo = "/root/eggs"
  
  $gem_repo = "/root/gems"

  $nailgun_package = "Nailgun"
  $nailgun_version = "0.1.0"

  $nailgun_group = "nailgun"
  $nailgun_user = "nailgun"
  
  class { "cobbler::server":
    server              => $ipaddress,
    
    domain_name         => $domain,
    name_server         => $ipaddress,
    next_server         => $ipaddress,
    
    dhcp_start_address  => ipcalc_network_nth_address($ipaddress, $netmask, "first"),
    dhcp_end_address    => ipcalc_network_nth_address($ipaddress, $netmask, "last"),
    dhcp_netmask        => $netmask,
    dhcp_gateway        => $ipaddress,
    dhcp_interface      => 'eth0',

    cobbler_user        => $cobbler_user,
    cobbler_password    => $cobbler_password,
    
    pxetimeout          => '0'
  } ->
        

  class { "cobbler::distro::centos63-x86_64":
    http_iso => $centos_iso,
    ks_url   => "cobbler",
  } ->

  class { "cobbler::profile::centos63-x86_64":
    ks_repo => $centos_repos,
  }

  class { "mcollective::rabbitmq":
    stompuser => "mcollective",
    stomppassword => "AeN5mi5thahz2Aiveexo",
  }

  class { "mcollective::client":
    pskey => $mco_pskey,
    stompuser => $mco_stompuser,
    stomppassword => $mco_stomppassword,
    stomphost => $ipaddress,
    stompport => "61613"
  }
              
  class { "puppetmaster" :
        puppet_master_hostname => "${hostname}.${domain}"
  }
      
  class { "nailgun":
    package => $nailgun_package,
    version => $nailgun_version,
    nailgun_group => $nailgun_group,
    nailgun_user => $nailgun_user,
    venv => "/opt/nailgun",

    # pip_index => "--no-index",
    pip_find_links => "-f file://${pip_repo}",
    gem_repo => $gem_repo,

    databasefile => "/var/tmp/nailgun.sqlite",
    staticdir => "/opt/nailgun/usr/share/nailgun/static",
    templatedir => "/opt/nailgun/usr/share/nailgun/static",
    logfile => "/var/tmp/nailgun.log",

    cobbler_url => "http://localhost/cobbler_api",
    cobbler_user => $cobbler_user,
    cobbler_password => $cobbler_password,

    mco_pskey => $mco_pskey,
    mco_stompuser => $mco_stompuser,
    mco_stomppassword => $mco_stomppassword,

    naily_user => "naily",
    naily_password => "Pheilohv6iso",
    
    puppet_master_host => "${hostname}.${domain}"
  }

}
