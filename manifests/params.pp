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
# Josh Beard <josh@signalboxes.net>
#
# === Copyright
#
# Copyright 2014 Josh Beard, unless otherwise noted.
#
class mco_agent_shell::params {

  $ensure = 'present'
  $source = "puppet:///modules/${module_name}"

  case $::kernel {
    'windows': {
      unless $::is_pe {
        fail("${module_name} only supports Puppet Enterprise on Windows")
      }
      $owner      = undef
      $group      = undef
      $mco_libdir = "${::common_appdata}/PuppetLabs/mcollective/etc/plugins/mcollective"
    }
    'linux': {
      $owner = 'root'
      $group = '0'
      ## Allow the user to specify a custom mco_libdir.  Otherwise, default it
      ## to standard locations for PE and POSS
      if $::is_pe {
        $mco_libdir = '/opt/puppet/libexec/mcollective/mcollective'
      }
      else {
        $mco_libdir = '/usr/libexec/mcollective/mcollective/'
      }
    }
    default: {
      fail("${::kernel} is not supported by ${module_name}")
    }
  }


}
