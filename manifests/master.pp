# Provides the puppet master setup.
#
# Using supervisord and nginx, ensures that the puppet master will run on the
# local host in production mode. See Wrangling Servers referenced in project
# README for more details.
class puppet::master {
  include nginx, puppet::package

  package { 'thin':
    ensure => present,
    provider => gem,
  }

  # The Nginx business. Define the master vhost--set as default for the box on
  # which it is to run--and the upstream proxies to the thin servers actually
  # _running_ puppet.
  nginx::resource::upstream { 'puppet-production':
    ensure => present,
    members =>
    [
     'unix:/var/run/puppet/master.00.sock',
     'unix:/var/run/puppet/master.01.sock',
     'unix:/var/run/puppet/master.02.sock',
    ]
  }
  nginx::resource::vhost { 'default':
    content => template('puppet/vhost.erb'),
  }

  # Configure supervisord to invoke and maintain the puppet master.
  supervisor::service { puppetmaster :
    ensure    => running,
    enable    => true,
    numprocs  => 3,
    command   => "/usr/bin/thin start -e development --socket /var/run/puppet/master.%(process_num)02d.sock --user puppet --group puppet --chdir /etc/puppet -R /etc/puppet/config.ru",
    startsecs => 3,
    require   => Class['puppet::package'],
    subscribe => Class['puppet::package'],
  }
}
