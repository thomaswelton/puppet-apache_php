# A Boxen-focused Apache Vhost setup helper
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
#     dir =>
#       The directory to clone the project to.
#       Defaults to "${boxen::config::srcdir}/${name}".
#
#     memcached =>
#       If true, ensures memcached is installed.
#
#     beanstalk =>
#       If true, ensures beanstalk is installed.
#
#     mysql =>
#       If set to true, ensures mysql is installed and creates databases named
#       "${name}_development" and "${name}_test".
#       If set to any string or array value, creates those databases instead.
#
#     redis =>
#       If true, ensures redis is installed.
#
#     php =>
#       If given a string, ensures that php version is installed.
#       Also creates "${dir}/.php-version" with content being this value.
#
#     source =>
#       Repo to clone project from. REQUIRED. Supports shorthand <user>/<repo>.
#
#     host =>
#       The hostname to use when accessing the application.

define apache_php::project(
  $port,
  $source,
  $docroot       = undef,
  $dir           = undef,
  $memcached     = undef,
  $beanstalk     = undef,
  $mysql         = undef,
  $redis         = undef,
  $php           = undef,
  $host = undef,
  $nginxproxy = undef,
) {
  include boxen::config
  include apache
  include apache::module::mod_fastcgi

  $vhost_docroot = $docroot ? {
    undef   => "${boxen::config::srcdir}/${name}",
    default => $docroot
  }

  $hostname = $host ? {
    undef   => "${name}.dev",
    default => $host
  }

  $repo_dir = $dir ? {
    undef   => "${boxen::config::srcdir}/${name}",
    default => $dir
  }

  repository { $repo_dir:
    source => $source
  }

  if $memcached {
    include memcached
  }

  if $beanstalk {
    include beanstalk
  }

  if $zookeeper {
    include zookeeper
  }

  if $mysql {
    $mysql_dbs = $mysql ? {
      true    => ["${name}_development", "${name}_test"],
      default => $mysql,
    }

    mysql::db { $mysql_dbs: }
  }

  if $redis {
    include redis
  }

  if $php {
    # Set the local version of PHP
    php::local { $repo_dir:
      version => $php,
      require => Repository[$repo_dir],
    }

    # Vhost with 5.4.11
    apache_php::vhost { $name:
      port => 10080,
      php_version => $php,
      docroot => $docroot,
    }
  }

  if $nginxproxy {
    # Proxy the apache server through nginx running on port 80
    include nginx::config
    include nginx

    file { "${nginx::config::sitesdir}/${name}.conf":
      content => template('apache_php/config/nginx.conf.erb'),
      require => File[$nginx::config::sitesdir],
      notify  => Service['dev.nginx'],
    }
  }

}