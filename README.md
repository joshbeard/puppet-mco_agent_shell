# mco_agent_shell

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with mco_agent_shell](#setup)
    * [What mco_agent_shell affects](#what-mco_agent_shell-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with mco_agent_shell](#beginning-with-mco_agent_shell)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Installs the Puppet Labs Mcollective Agent

Reference:
[https://github.com/puppetlabs/mcollective-shell-agent](https://github.com/puppetlabs/mcollective-shell-agent)

#### Disclaimer

This module contains the plugin itself, which is undesirable.  However, there
is currently no package for Puppet Enterprise (only POSS). We could source this
over HTTP, stage it, extract it, and deploy the necessary contents, but that
is overly complex, dirty, and fragile.  If a PE package is made available,
this module should be discontinued for use.

## Module Description

Installs the Agent and, optionally, the Application

__NOTE:__ This does _not_ manage the `pe-mcollective` service.  That service
must be restarted after deploying the agent that this module provides.

## Setup

### Beginning with mco_agent_shell

To install the Mcollective agent:

```puppet
include mco_agent_shell
```

This should be available on any node that you want to run commands against.

To install the Mcollective application:

```puppet
include mco_agent_install::application
```

## Usage

To ensure the agent is absent from the system:

```puppet
class { 'mco_agent_shell':
  ensure => 'absent',
}
```

Install the files from a different modules:

```puppet
class { 'mco_agent_shell':
  source => 'puppet:///modules/theothermodule',
}
```

You'll need to ensure the `pe-mcollective` module gets restarted when you
deploy this module.  We are not managing that service here - that's up to you.

You can do something like this:

```puppet
class { 'mco_agent_shell':
  ensure => 'present',
  notify => Service['pe-mcollective'],
}
```

## Reference

Refer to [https://github.com/puppetlabs/mcollective-shell-agent](https://github.com/puppetlabs/mcollective-shell-agent)

## Limitations


## Development

Let's not.
