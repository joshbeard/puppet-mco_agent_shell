## Remove the Mcollective Shell 'application'
class { 'mco_agent_shell::application':
  ensure => 'absent',
}
