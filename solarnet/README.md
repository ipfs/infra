# solarnet

This network runs the IPFS bootstrap + gateway nodes. There are 9 machines, all on Digital Ocean in various different data centers across the world. See the `hosts` file.

## Node Setup

Each solarnet computer runs one ipfs process. it handles both bootstrap and http://gateway.ipfs.io.

They have:

- docker - runs things in a uniform, clean environment.
- nginx - which proxies over to gateway.
- ipfs daemon - which runs the gateway.

### nginx

nginx absorbs all the outside requests coming to the gateways. This allows us to:
- deal with HTTP traffic better (nginx is a beast!)
- not have to worry about a number of attacks on HTTP servers
- use proxy-pass to an ipfs gateway
- route traffic to other gateways if local gateway ipfs program crashes

### ipfs daemon

Gets its repo mounted as a volume, and exposes the ports 4001 (swarm), 5001 (API), and 8080 (gateway) to the host.

## Getting Started

### ansible

This repository uses ansible for _almost_ everything.  ansible is fairly nice, but can also be annoying. it comes well recommended by others, though none of us are experts with it. (@jbenet would prefer to eiter use shell scripts or ansible, but probably not other tools _more_ complicated than ansible (e.g. chef / puppet), [@lgierth agrees](https://github.com/lgierth/provsn)).

```sh
# implicit dependencies: virtualenv pip
# install stuff in requirements.txt
$ make deps

# activate the virtualenv
$ . venv/bin/activate

# see if it works
(venv)$ which ansible
(venv)$ ansible solarnet -a 'docker ps'
```

## Deploying

Please commit the changed `roles/ipfs/vars/main.yml` when deploying an update!

```sh
# update the ipfs role's commit reference
$ make ipfs_ref

# deploy to all solarnet hosts
(venv)$ ansible-playbook -l solarnet solarnet.yml

# deploy one host at a time
(venv)$ ansible-playbook -f 1 -l solarnet solarnet.yml

# deploy only pluto.i.ipfs.io
(venv)$ ansible-playbook -l pluto solarnet.yml
```

or simply:

```sh
$ make cake
```

### Restarting

```sh
(venv)$ ansible solarnet -a 'docker restart ipfs'
```

## Troubleshooting

### disk space

A couple of things fill up the disk. These should be fixed, or the cleanup
one-liners be automated.

```sh
# docker's container output logs. restart container so it reopns the logs.
(venv)$ ansible solarnet -f 1 -m shell -a 'rm -v /var/lib/docker/containers/*/*-json.log ; docker restart ipfs_master'

# old docker containers and images
(venv)$ ansible solarnet -m shell -a 'docker rm $(docker ps -f "status=exited" -aq) ; docker rmi $(docker images -f "dangling=true" -aq)'

# all of the above
(venv)$ ./cleanup.sh
```

### unsupported parameter for module: restart_policy

You're probably using the system version of Ansible, and it is outdated (< 1.9). Make sure to follow the Ansible setup steps above, and load the virtualenv. This will load a working version of Ansible.
