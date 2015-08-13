# solarnet: gateway and bootstrap nodes

- [Overview](#overview)
- [Getting Started](#getting-started)
- [Secrets](#secrets)
- [Common Tasks](#common-tasks)
- [Troubleshooting](#troubleshooting)
- [Monitoring](#monitoring)


This repository contains Ansible playbooks which maintain
http://gateway.ipfs.io and the default IPFS bootstrap nodes.

Solarnet currently consists of 9 hosts.
all on DigitalOcean in various different data centers across the world.
See the `hosts` file.

## Overview

Each host gets provisioned with the following:

- nginx
- IPFS daemon
- cjdns
- Docker
- SSH authorized_keys

Grafana and Prometheus run on one host.

### nginx

The frontend HTTP server for both the Internet and Hyperboria.
Serves http://gateway.ipfs.io and http://h.gateway.ipfs.io.

To whitelisted cjdns nodes, it also serves http://metrics.i.ipfs.io,
as well as host metrics and the IPFS API,
so that Prometheus can scrape them.

### IPFS daemon

Exposes its swarm interface (port 4001) to the Internet,
so that other nodes can peer with and bootstrap from it.
Exposes API (port 5001) and gateway (port 8080) to nginx.

### cjdns

The Solarnet nodes are peered into the Hyperboria network,
which operates on an encrypted peer-to-peer routing protocol called cjdns.

## Getting Started

Requirements:

- virtualenv
- pip

```sh
# install ansible and other dependencies
$ make deps

# activate the virtualenv
$ . venv/bin/activate

# see if it works
(venv)$ which ansible
(venv)$ ansible all -a 'whoami'
```

## Secrets

IPFS and cjdns private keys, SSL certificates, and cjdns peering credentials,
are tracked by Git in a secret repository, in encrypted form.
We need to decrypt them for usage, and encrypt them for committing changes.

```sh
# initialize and decrypt
$ git clone https://example.net/secrets.git secrets/
$ echo "the-key" > ../solarnet.key
$ ./secrets.sh -d

# make changes and encrypt
$ vim secrets_plaintext/secrets.yml
$ ./secrets.sh -e
$ cd secrets/
$ git add secrets.yml
$ git commit -m 'Add some password or so'
```

You can also pipe the key instead of writing it to a file:

```sh
$ echo "the-key" | ./secrets.sh -d
```

## Common Tasks

### Deploy any changes

```sh
# to all hosts
(venv)$ ansible-playbook solarnet.yml

# to one host
(venv)$ ansible-playbook -l pluto solarnet.yml
```

### Update IPFS and/or cjdns

```sh
(venv)$ make ipfs_ref
(venv)$ make cjdns_ref
(venv)$ ansible-playbook solarnet.yml
```

### Reclaim Disk Space

```sh
(venv)$ ./cleanup.sh
```

### Docker Container Status

```sh
(venv)$ ansible all -a 'docker ps'
```

### Restart IPFS

```sh
(venv)$ ansible all -f 1 -a 'docker restart ipfs'
```

## Troubleshooting

### disk space

A couple of things fill up the disk.
These should be fixed, or the cleanup one-liners be automated.

```sh
# docker's container output logs. restart container so it reopns the logs.
(venv)$ ansible -f 1 -m shell -a 'rm -v /var/lib/docker/containers/*/*-json.log ; docker restart ipfs'

# old docker containers and images
(venv)$ ansible -m shell -a 'docker rm $(docker ps -f "status=exited" -aq) ; docker rmi $(docker images -f "dangling=true" -aq)'

# all of the above
(venv)$ ./cleanup.sh
```

### unsupported parameter for module: restart_policy

You're probably using the system version of Ansible, and it is outdated (< 1.9).
Make sure to follow the Ansible setup steps above, and load the virtualenv.
This will load a working version of Ansible.

## Monitoring

We use Prometheus to scrape and store timeseries
from IPFS and the hosts themselves.
Grafana provides the dashboard UI.

Both are available at http://metrics.i.ipfs.io
http://metrics.i.ipfs.io/prometheus, respectively.

- You need to be peered into the Hyperboria cjdns network
  in order to reach the address that this domain name points to.
- Your cjdns address needs to be whitelisted.

### Cjdns

In addition to serving http://h.gateway.ipfs.io,
we use cjdns for a very simple VPN based on an IP address whitelist.

```sh
$ git clone https://github.com/hyperboria/cjdns.git
$ cd cjdns/
$ ./do
$ ./cjdroute --genconf > cjdroute.conf
$ ./cjdroute < cjdroute.conf
$ killall cjdroute

# or, on osx
$ brew install cjdns

# or, on ubuntu, repo = precise|trusty|utopic|vivid
$ echo "deb http://ubuntu.repo.cjdns.ca/ <repo> main" > /etc/apt/sources.list.d/cjdns.list
$ apt-get update && apt-get install cjdns
```

This creates a `tunX` network interface,
which grabs all `fc00::/8` traffic and hands it to cjdns.

Scripts for various init systems are provided in `contrib/`.

### Peering

Cjdns nodes peer automatically on local networks,
but on WANs like the internet, peering requires credentials.
You can peer with the Solarnet cjdns nodes
by using one of the `cjdns_authorized_passwords` in `secrets.yml`.

Note that peering with any other node in the Hyperboria network is sufficient, too.

You can check the status of your peerings:

```sh
$ watch tools/peerStats
```

Or check connectivity to solarnet:

```sh
$ ping6 h.gateway.ipfs.io
```

### Authentication

Since IP packets in cjdns are authenticated and encrypted,
we can use the HTTP client's IP address for authentication,
instead of Basic Auth or another login mechanism.

Restricted HTTP services listen only on the cjdns IPv6 address,
and allow access only to the following clients:

- localhost
- All `cjdns_identities` nodes in `secrets.yml`
- All `metrics_whitelist` nodes in `secrets.yml`

For access to Grafana and Prometheus,
add your cjdns address to `metrics_whitelist`.
