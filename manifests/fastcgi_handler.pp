define apache_php::fastcgi_handler ($php_version, $ensure = 'present') {
  require apache::config

  file { "${apache::config::configdir}/other/10-fastcgi-${name}.conf":
    ensure  => $ensure,
    content => template('apache_php/fastcgi_handler.conf.erb'),
  }
}
