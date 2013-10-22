# A Boxen-focused Apache Vhost Setup Helper with PHP.
#
# Options:
#
#     docroot =>
#       The directory to use as the document root.
#       Defaults to "${boxen::config::srcdir}/${name}".
#
#     port =>
#       Port for Apache to listen on. REQUIRED.
#
#     php_version =>
#        PHP Version to use. REQUIRED.
#

define apache_php::vhost (
  $port,
  $php_version,
  $docroot  = undef,
  $host = undef,
) {
  require apache

  $vhost_docroot = $docroot ? {
    undef   => "${boxen::config::srcdir}/${name}",
    default => $docroot
  }

  $hostname = $host ? {
    undef   => "${name}.dev",
    default => $host
  }

  file { "${apache::config::sitesdir}/${name}.conf":
    require => File[$apache::config::sitesdir],
    content => template('apache_php/config/vhost_php.conf.erb'),
  }
}
