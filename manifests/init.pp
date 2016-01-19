# == Class: mco_agent_shell
#
# Installs the Puppet Labs Mcollective Agent
# Reference: https://github.com/puppetlabs/mcollective-shell-agent
#
# This module contains the plugins, which is undesirable.  However, there is
# currently no package for Puppet Enterprise (only POSS). We could source this
# over HTTP, stage it, extract it, and deploy the necessary contents, but that
# is overly complex, dirty, and fragile.  If a PE package is made available,
# this module should be discontinued for use.
#
# === Parameters
#
# Document parameters here.
#
# [*ensure*]
#   Specifies the state of the agent and application.
#   Valid values are: present, installed, and absent.
#   'present' and 'installed' are synonomous and will ensure the files are
#   present on a system.  'absent' will ensure they're not present.
#   Defaults to 'present'
#
# [*source*]
#   The BASE of the 'source' to pass to the file resources.  As these files
#   are managed with the 'file' resource, this assumes the source is the base
#   of a puppet:// URI or a local file path.  E.g. this should simply point
#   to the module that contains the files in its 'files' directory.
#   Defaults to: puppet:///modules/${module_name} (this module)
#
# [*libdir*]
#   Specifies the absolute path to the Mcollective lib directory.
#   On PE, this defaults to /opt/puppet/libexec/mcollective/mcollective
#   On POSS, this defaults to /usr/libexec/mcollective/mcollective
#
# [*owner*]
#   What user should own the files.
#   Defaults to: 'root'
#
# [*group*]
#   What group should own the files.
#   Defaults to: 'root'
#
# [*service*]
#   The name of the Mcollective service to notify
#
# [*application*]
#   Whether to include the application or not
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*is_pe*]
#   If this top-scope variable is present, the libdir will be set to the
#   PE location.  Otherwise, POSS' location for mcollective libraries.
#
# === Examples
#
#  class { 'mco_agent_shell':
#    ensure => 'present',
#  }
#
# === Authors
#
# Josh Beard <josh@signalboxes.net>
#
# === Copyright
#
# Copyright 2014 Josh Beard, unless otherwise noted.
#
class mco_agent_shell (
  $ensure      = $mco_agent_shell::params::ensure,
  $source      = $mco_agent_shell::params::source,
  $libdir      = $mco_agent_shell::params::libdir,
  $owner       = $mco_agent_shell::params::owner,
  $group       = $mco_agent_shell::params::group,
  $service     = $mco_agent_shell::params::service,
  $application = true,
) inherits mco_agent_shell::params {

  validate_re($ensure, '(present|installed|absent)')
  validate_re($source, '^(\/|puppet:\/\/)',
    'source should be a Puppet URI or absolute path')
  validate_absolute_path($libdir)
  validate_bool($application)


  # Allow for the removal of everything this class manages and be smart
  # about what type of 'ensure' parameter we pass to resources
  case $ensure {
    /present|installed/: {
      $file_ensure = 'file'
      $dir_ensure  = 'directory'
    }
    'absent': {
      $file_ensure = 'absent'
      $dir_ensure  = 'absent'
    }
    default: {
      fail("Invalid parameter for ensure: ${ensure}")
    }
  }

  File {
    ensure => $file_ensure,
    owner  => $owner,
    group  => $group,
    mode   => '0644',
  }

  # This anchor conditionally notifies the pe-mcollective service, but only if
  # it exists. It is implemented this way to avoid a hard-dependency on
  # Service['pe-mcollective'] being defined. If the service doesn't exist in
  # the catalog this is a no-op.
  anchor { 'mco_shell_notify': } ~> Service <| title == $service |>

  file { "${libdir}/agent/shell":
    ensure => $dir_ensure,
    force  => true,
  }

  file { "${libdir}/agent/shell.rb":
    source => "${source}/agent/shell.rb",
  }

  file { "${libdir}/agent/shell.ddl":
    source => "${source}/agent/shell.ddl",
  }

  file { "${libdir}/agent/shell/job.rb":
    source => "${source}/agent/shell/job.rb",
  }

  if $application {
    file { "${libdir}/application/shell":
      ensure => $dir_ensure,
      force  => true,
    }

    file { "${libdir}/application/shell.rb":
      source => "${source}/application/shell.rb",
    }

    file { "${libdir}/application/shell/prefix_stream_buf.rb":
      source => "${source}/application/shell/prefix_stream_buf.rb",
    }

    file { "${libdir}/application/shell/watcher.rb":
      source => "${source}/application/shell/watcher.rb",
    }
  }

}
