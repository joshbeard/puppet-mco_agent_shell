## Remove the Mcollective Shell 'agent'
class { 'mco_agent_shell':
  ensure => 'absent',
  source => 'puppet:///modules',
}
