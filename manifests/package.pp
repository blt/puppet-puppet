# Provides both puppet and thin packages.
class puppet::package {
  if defined('apt::alternatives') {
    apt::alternatives { 'puppet':
      ensure => present,
      path => '/var/lib/gems/1.9.1/bin/puppet',
      require => Package['puppet'],
    }
  }

  package { 'puppet' :
    ensure => '2.7.9',
    provider => gem,
  }
}
