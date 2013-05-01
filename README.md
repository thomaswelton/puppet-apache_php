# Apache/PHP Puppet Module for Boxen

[![Build Status](https://travis-ci.org/webflo/puppet-apache_php.png)](https://travis-ci.org/puppet/puppet-apache_php)

Requires the following boxen modules:

* `apache`
* `php`

## Examples

```puppet
include apache::module::mod_fastcgi

# FastCGI for PHP 5.3.24
apache_php::fastcgi_handler { "5.3.24":
  php_version => "5.3.24"
}

# FastCGI for PHP 5.4.11
apache_php::fastcgi_handler { "5.4.11":
  php_version => "5.4.11"
}

# Apache vhosts with PHP 5.4.11
apache_php::vhost { "example":
  port => 80,
  php_version => "5.4.11",
  docroot => "/Users/${::luser}/Sites/example.dev/htdocs",
}

```