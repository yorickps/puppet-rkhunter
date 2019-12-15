#
# @summary install the rkhunter package and initialize it
#
# @api private
#
# @param package_name name of the rkhunter package that will be installed
#
class rkhunter::packages(
  $package_name = $rkhunter::package_name,
) {

  assert_private()

  package { 'rkhunter':
    ensure => installed,
    name   => $package_name,
  }

  file { '/usr/local/bin/rktask':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/rkhunter/rktask',
  }

  # Run rkhunter --propupd after installation of package
  exec { '/usr/bin/rkhunter --propupd':
    unless  => '/usr/bin/test -f /var/lib/rkhunter/db/rkhunter_prop_list.dat && /usr/bin/test -f /var/lib/rkhunter/db/rkhunter.dat',
    require => [
      Package['rkhunter'],
      File['/etc/rkhunter.conf'],
    ],
  }
}
