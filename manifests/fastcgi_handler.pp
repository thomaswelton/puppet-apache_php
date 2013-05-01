define apache_php::fastcgi_handler ($php_version, $ensure = 'present') {
  file { "/Users/${::luser}/Sites/.vhosts/fastcgi-${name}.conf":
    ensure  => $ensure,
    content => template('apache_php/fastcgi_handler.conf.erb'),
  }
}