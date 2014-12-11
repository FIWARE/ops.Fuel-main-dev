# Minimal install of puppetdb
class { 'puppetdb':
  database => 'embedded',
  disable_ssl => true,
  listen_address => '0.0.0.0',
  listen_port => '58080',
  # open_listen_port => true,  # This will require iptables, maybe we can skip it
  # open_ssl_listen_port => true,  # This will require iptables, maybe we can skip it
  puppetdb_service_status => 'stopped',
  ssl_listen_address => 'master.domain.tld',
  ssl_listen_port =>  '58443'
}


# Site-specific PuppetDB settings. Declare this class on any node that gets the puppetdb::server class.
class site::puppetdb::server::extra {

  # Get PuppetDB confdir
  include puppetdb::params
  $confdir = $puppetdb::params::confdir

  # No logging means log to stdout
  ini_setting {'no-log-config':
    ensure  => absent,
    path    => "${confdir}/config.ini",
    section => 'global',
    setting => 'logging-config',
  }

}

include site::puppetdb::server::extra


include nginx

file { '/etc/ssl/nginx':
  ensure => directory,
  owner => $nginx::params::nx_daemon_user,
  mode => 750,
  } ->
  file { '/root/.rnd':
    ensure => present,
    content => $random,
    mode => 600,
    owner => 'root',
    } ->
    openssl::certificate::x509 { $fqdn:
      ensure => present,
      country => 'IT',
      organization => 'Create-Net',
      unit => 'SmartI',
      state => 'Trentino',
      locality => 'Trento',
      commonname => $fqdn,
      email => 'daniele.pizzolli@create-net.org',
      days => 3660,
      base_dir => '/etc/ssl/nginx',
      force => true,
      owner => $nginx::params::nx_daemon_user,
      } ->
      nginx::resource::upstream { 'puppetdbhost':
        ensure => present,          
        members => [
                    'localhost:58080'
                    ],
        } ->
        nginx::resource::vhost { 'master.domain.tld':
          ensure => present,  
          # ssl_only => true,
          listen_port => '58443',
          proxy => 'http://puppetdbhost',
          ssl => true,
          # ssl_cert => '/var/lib/puppet/ssl/certs/example.com.pem',
          # ssl_key => '/var/lib/puppet/ssl/private_keys/example.com.pem',
          ssl_cert => "/etc/ssl/nginx/${fqdn}.crt",
          ssl_key => "/etc/ssl/nginx/${fqdn}.key",  
          ssl_port => '58443'
        }
        # ->
        # service { 'nginx':
        #   ensure => 'stopped',
        #   enable => false,
        # }
