# solarnet

- [Overview](#overview)
- [Getting Started](#getting-started)
- [Secrets](#secrets)
- [Common Tasks](#common-tasks)
- [Troubleshooting](#troubleshooting)
- [Monitoring](#monitoring)

This repository contains Ansible playbooks which maintain:

- https://ipfs.io and the deprecated gateway.ipfs.io
- The default IPFS [bootstrap](https://github.com/ipfs/go-ipfs/blob/master/core/commands/bootstrap.go) nodes
- Bots for irc://chat.freenode.net/#ipfs
- Monitoring

## Overview

Solarnet currently consists of 12 hosts.
most of them on DigitalOcean in various different data centers across the world.
The storage nodes are hosted with different hosters.
See the `hosts` file.

All hosts are peered into the cjdns network [Hyperboria](https://hyperboria.net),
which is also the transport for the VPN between them.
The VPN grants access to internal services like http://metrics.i.ipfs.io, and each IPFS node's API.
Access control is merely an allowlist of cjdns IPv6 addresses.

All hosts get provisioned with the following:

- nginx
- cjdns
- Docker
- SSH authorized_keys
- Prometheus node_exporter

Depending on their role they also get provisioned with:

- IPFS
- SSL cert and key for ipfs.io
- Grafana and Prometheus
- Pinbot

See the `hosts` file for the role associations.

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
You can base your own secret repository off `secrets.yml.example`.

```sh
# initialize and decrypt
$ git clone https://github.com/protocol/infrastructure-secrets.git secrets/
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

Note that `./secrets.sh -e` rewrites all files, regardless of whether they actually change. That's why we stage only `secrets.yml` in the example above.

## Common Tasks

### Deploy any changes

```sh
# to all hosts
(venv)$ ./full.sh all

# to one host
(venv)$ ./full.sh pluto

# only ipfs changes, to storage hosts
(venv)$ ansible-playbook -l storage ipfs.yml
```

### Update IPFS or cjdns

```sh
(venv)$ make ipfs_ref
(venv)$ ansible-playbook ipfs.yml
(venv)$ git add roles/ipfs/vars/main.yml
(venv)$ git commit -m 'ipfs: update to latest master'

(venv)$ make cjdns_ref
(venv)$ ansible-playbook cjdns.yml
(venv)$ git add roles/cjdns/vars/main.yml
(venv)$ git commit -m 'cjdns: update to latest master'
```

### GC / Reclaim Disk Space

There's disk space telemetry: http://metrics.i.ipfs.io/dashboard/db/meta

```sh
# runs on all gateway hosts in parallel
(venv)$ ansible gateway -a 'docker exec -i ipfs ipfs repo gc'
```

### Docker Container Status

```sh
(venv)$ ansible all -a 'docker ps'
```

### Restart IPFS

```sh
# two hosts in parallel
(venv)$ ansible all -f 2 -a 'docker restart ipfs'
```

### Tail logs

```sh
# ipfs
(venv)$ ssh root@pluto.i.ipfs.io docker exec -i ipfs ipfs log tail

# ipfs.io nginx errors
(venv)$ ssh root@earth.i.ipfs.io /opt/nginx/logs/default.error.log
```

### Reload nginx

Changes to the nginx, IPFS, or cjdns configurations should trigger an nginx reload.
If a playbook fails *after* writing an updated config file,
but *before* the "reload handler" triggers the nginx reload,
then the reload will never happen, and we have to do it manually.

```sh
(venv) ansible all -a 'docker exec -i nginx sh -c '/etc/init.d/nginx configtest && /etc/init.d/nginx reload''
```

## Troubleshooting

### unsupported parameter for module: restart_policy

You're probably using the system version of Ansible, and it is outdated (< 1.9).
Make sure to follow the Ansible setup steps above, and load the virtualenv.
This will load a working version of Ansible.

## Monitoring

We use Prometheus to scrape and store timeseries
from IPFS and the hosts themselves.
Grafana provides the dashboard UI.

Both are available at http://metrics.i.ipfs.io
and http://metrics.i.ipfs.io/prometheus, respectively.
There are two ways of access:

- cjdns
  - You need to be peered into the Hyperboria cjdns network
    in order to reach the address that this domain name points to.
  - Your cjdns address needs to be allowlisted.
- SSH port-forwarding
  - `ssh -L 8080:metrics.i.ipfs.io:80 root@<any-solarnet-host>.i.ipfs.io`
  - http://localhost:8080

### Cjdns

In addition to serving http://h.ipfs.io,
we use cjdns for a very simple VPN based on an IP address allowlist.

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
by generating peering credentials (`./peering.sh gateway solarnet`),
and adding them to `cjdroute.conf.

Note that peering with any other nodes in the Hyperboria network is sufficient, too.

You can check the status of your peerings:

```sh
$ watch tools/peerStats
```

Or check connectivity to solarnet:

```sh
$ ping6 h.ipfs.io
```

### Authentication

Since IP packets in cjdns are authenticated and encrypted,
we can use the HTTP client's IP address for authentication,
instead of Basic Auth or another login mechanism.

Restricted HTTP services listen only on the cjdns IPv6 address,
and allow access only to the following clients:

- localhost
- All `cjdns_identities` nodes in `secrets.yml`
- All `metrics_allowlist` nodes in `secrets.yml`

For access to Grafana and Prometheus,
add your cjdns IPv6 address to `metrics_allowlist`.
