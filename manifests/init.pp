# === Class: nexus
#
# Install and configure Sonatype Nexus
#
# === Parameters
#
# [*version*]
#   The version to download.
#
# [*revision*]
#   The revision of the archive. This is needed for the name of the
#   directory the archive is extracted to.  The default should suffice.
#
# [*nexus_root*]
#   The root directory where the nexus application will live and tarballs
#   will be downloaded to.
#
# === Examples
#
# class{ 'nexus':
#   var => 'foobar'
# }
#
# === Authors
#
# Tom McLaughlin <tmclaughlin@hubspot.com>
#
# === Copyright
#
# Copyright 2013 Hubspot
#
class nexus (
  $version        = $nexus::params::version,
  $revision       = $nexus::params::revision,
  $nexus_root     = $nexus::params::nexus_root,
  $nexus_home_dir = $nexus::params::nexus_home_dir
) inherits nexus::params {
  include stdlib

  # Bail if $version is not set.  Hopefully we can one day use 'latest'.
  if ($version == 'latest') or ($version == undef) {
    fail('Cannot set version nexus version to "latest" or leave undefined.')
  }

  anchor{'nexus::begin':}

  class{'nexus::package':
    version         => $version,
    revision        => $revision,
    nexus_root      => $nexus_root,
    $nexus_home_dir => $nexus_home_dir,
    require         => Anchor['nexus::begin']
  }

  class{'nexus::service':}

  anchor{'nexus::end':
    require => Service['nexus::service']
  }
}