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
# [*mco_libdir*]
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
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*is_pe*]
#   If this top-scope variable is present, the mco_libdir will be set to the
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
# Josh Beard <beard@puppetlabs.com>
#
# === Copyright
#
# Copyright 2014 Josh Beard, unless otherwise noted.
#
class mco_agent_shell (
  $ensure     = $mco_agent_shell::params::ensure,
  $source     = $mco_agent_shell::params::source,
  $mco_libdir = $mco_agent_shell::params::mco_libdir,
  $owner      = $mco_agent_shell::params::owner,
  $group      = $mco_agent_shell::params::group,
) inherits mco_agent_shell::params {

  validate_re($ensure, '(present|installed|absent)')
  validate_re($source, '^(\/|puppet:\/\/)',
    'source should be a Puppet URI or absolute path')
  validate_absolute_path($mco_libdir)


  ## Allow for the removal of everything this class manages and be smart
  ## about what type of 'ensure' parameter we pass to resources
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

  file { 'mcoagent_shell_agent':
    ensure => $file_ensure,
    path   => "${mco_libdir}/agent/shell.rb",
    source => "${source}/agent/shell.rb",
    owner  => $owner,
    group  => $group,
  }

  file { 'mcoagent_shell_ddl':
    ensure => $file_ensure,
    path   => "${mco_libdir}/agent/shell.ddl",
    source => "${source}/agent/shell.ddl",
    owner  => $owner,
    group  => $group,
  }

  file { 'mcoagent_shell_libs':
    ensure => $dir_ensure,
    path   => "${mco_libdir}/agent/shell",
    owner  => $owner,
    group  => $group,
    force  => true,
  }

  file { 'mcoagent_shell_lib_job':
    ensure => $file_ensure,
    path   => "${mco_libdir}/agent/shell/job.rb",
    source => "${source}/agent/shell/job.rb",
    owner  => $owner,
    group  => $group,
  }

}
