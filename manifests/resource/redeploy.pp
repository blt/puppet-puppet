class puppet::resource::redeploy (
  $ensure=present
)
{
  traut::resource::event { 'puppet-redeploy':
    ensure => $ensure,
    route  => 'puppet.redeploy',
    command => '/usr/bin/redeploy-puppet',
    user => 'root',
    group => 'root',
  }

  file { '/usr/bin/redeploy-puppet':
    ensure => $ensure ? { present => file, default => absent, },
    content => template('puppet/redeploy.erb'),
    mode => 0755,
  }
}
