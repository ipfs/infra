# infrastructure

[![](https://img.shields.io/badge/made%20by-Protocol%20Labs-blue.svg?style=flat-square)](http://ipn.io)
[![](https://img.shields.io/badge/project-IPFS-blue.svg?style=flat-square)](http://ipfs.io/)
[![](https://img.shields.io/badge/freenode-%23ipfs-blue.svg?style=flat-square)](http://webchat.freenode.net/?channels=%23ipfs)
[![standard-readme compliant](https://img.shields.io/badge/standard--readme-OK-green.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

> Tools for maintaining infrastructure for the IPFS community.

- Introduction
- Getting started
- Usage
- Known issues
- Common tasks

TODO before @lgierth vacation:

- secrets submodule
- make parallelism less awkward
- fix unwanted `./provsn` parallelism
- make sure `./provsn help` is up-to-date
- migrate ansible/{common,ipfs,ipfs_gateway,nginx}
  - cjdns,metrics,node_exporter,pinbot remain todo
- migrate peering script

### Introduction

This repository contains the technical infrastructure of the IPFS community.

- Public HTTP-to-IPFS Gateway: https://ipfs.io
- Default bootstrap used by IPFS: `ipfs bootstrap`
- Private networking between the hosts
- Monitoring of services and hosts: http://metrics.ipfs.team
- Pinbot, an IRC bot in chat.freenode.net/#ipfs
- Seeding of $important objects, in `seeding/` (not really maintained at the moment)

Infrastructure that isn't contained here:

- Websites deployment: ipfs.io, dist.ipfs.io, blog.ipfs.io, chat.ipfs.io
- DNS settings for ipfs.io, ipld.io, multiformats.io, libp2p.io, orbit.chat, ipfs.team, protocol.ai
- TeamCity CI: http://ci.ipfs.team:8111

### Getting started

We use an experimental tool called Provsn to maintain the setup of hosts and services.
The fundamental principle of Provsn is that hosts are in a certain state,
and units of code are run to transition into a different state.

Provsn is a plain shell script, and each unit consists of shell scripts too:
- The `env` script exposes variables and functions to the unit itself, and other units.
- The `build` script is run on the client and builds container images, config files, etc.
- The `install` script is run on the host and transitions it into the desired state.

**Note:** there are a few bits of Ansible code left over, which are to be migrated to Provsn.
You can find them in the `ansible/` directory.

To test whether you're all set up, execute a simple command on all hosts.

```sh
> ./provsn exec all 'whoami'
pluto: root
uranus: root
[...]
```

Two environment variables can be used to alter Provsn's operation:

- `PROVSN_JOBS` -- this controls the number of hosts to run on in parallel, and defaults to 4.
- `PROVSN_TRACE` -- if set, this enables Bash tracing (`set -x`) for extensive debugging information.
  Note that this *will contain sensitive information and secrets*.

### Usage

### Known issues

- no verbose option, need to comment out dev-null-redirections in unit scripts

### Common tasks

- gathering ipfs debug info
- updating ipfs
- deploying a website
- adding a root user
- adding hashes to the blocklist

### Other community infrastructure:

More info in https://github.com/ipfs/community

- Github
  - https://github.com/ipfs
  - https://github.com/libp2p
  - https://github.com/ipld
  - https://github.com/multiformats
  - https://github.com/protocol
  - https://github.com/ipfsbot
- Communication
  - IRC: chat.freenode.net/#ipfs and https://chat.ipfs.io
  - ipfs-users group: https://groups.google.com/forum/#!forum/ipfs-users
  - Slack
  - https://twitter.com/ipfsbot
- CI / Testing
  - GitCop
  - TeamCity: http://ci.ipfs.team:8111
  - Travis CI
  - Circle CI

## Contribute

Feel free to join in. All welcome. Open an [issue](https://github.com/ipfs/infrastructure/issues)!

This repository falls under the IPFS [Code of Conduct](https://github.com/ipfs/community/blob/master/code-of-conduct.md).

### Want to hack on IPFS?

[![](https://cdn.rawgit.com/jbenet/contribute-ipfs-gif/master/img/contribute.gif)](https://github.com/ipfs/community/blob/master/contributing.md)

## License

MIT
