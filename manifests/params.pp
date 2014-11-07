# == Class: mco_agent_shell::params
#
# Private class that provides sane defaults for the mco_agent_shell module.
#
# === Parameters
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
# === Authors
#
# Josh Beard <beard@puppetlabs.com>
#
# === Copyright
#
# Copyright 2014 Josh Beard, unless otherwise noted.
#
class mco_agent_shell::params {

  $ensure = 'present'
  $source = "puppet:///modules/${module_name}"

  ## Allow the user to specify a custom mco_libdir.  Otherwise, default it
  ## to standard locations for PE and POSS
  if $is_pe {
    $mco_libdir = '/opt/puppet/libexec/mcollective/mcollective'
  }
  else {
    $mco_libdir = '/usr/libexec/mcollective/mcollective/'
  }

}
