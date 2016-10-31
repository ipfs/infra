## provsn

provsn is our homemade provisioning tool.

## Requirements

* parallel
* bash
* ssh
* jq
* readlink
* dirname
* find
* xargs
* sed
* awk
* uniq
* sort

## Concepts

provsn is a simple and nimble little tool, we just have a few concepts you need
to understand to be able to use it and contribute.

### Host

A host is a computer that you have ssh access to and want to manage. They
are all mapped in `env.sh` in the root directory.

Typically looks something like this:

```sh
# digitalocean-sfo1
pluto_ssh="root@104.236.179.241"
pluto_units=(${baseunits[@]} ${gatewayunits[@]})
```

### Unit

A unit is something that you can install and manage on a host. A unit needs to
have at least a `env.sh` file in it's directory. Typical structure:

```
nginx
├── 451.html
├── build.sh
├── env.sh
├── install.sh
└── nginx.conf
```

Both `451.html` and `nginx.conf` is unique for the nginx unit.

`env.sh` sets environment variables for this unit, in this case setting the nginx
version we want to use.

`build.sh` contains setup instructions for our `install.sh` script. In nginx case,
we copy `451.html` and `nginx.conf` to `out/` and then also create a `out/docker.opts`
file with our arguments to docker.

`install.sh` is the script that actually installs nginx on our hosts. We now have
access to our files in `out/` on our host, so we copy them to the right place and
compare if anything changed. If it did, we make sure to restart the docker container.

## How to use provsn

provsn is a simple bash tool that should work on all platforms. To run, it simply
execute the script.

```sh
./provsn <command> <@args>
```

## Common Tasks

### Gathering ipfs debug info

Grab the logs since `1 minute ago` on `pluto`

```sh
./provsn exec pluto "docker logs --since 1m ipfs"
```

### Updating IPFS on hosts

### Deploying a website

### Adding a root user

### Adding hashes to the blocklist
