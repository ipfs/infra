# Manage IPFS Infrastructure with Ansible

This repository contains the Ansible playbooks and roles for managing IPFS infrastructure: bootstrappers, gateways, preloaders.

## Getting Started

We use ansible >=2.8.0 which can be installed via `brew` in OSX or any Linux distro's package manger.


## Usage

Ansible can be used to run one-off (ad-hoc) modules or to run entire playbooks (collections of inventories and roles).

### Running ad-hoc commands

To get the number of container restarts from all bootstrap hosts in the inventory by runnning an one-off command:

```shell
# -b to run the command via sudo. -u ubuntu specifies the user on the remote host
cd ansible
ansible -i inventories/bootstrappers/hosts bootstrappers -m shell -a "docker inspect go-ipfs | grep RestartCount" -u ubuntu -b
```

### Running playbooks

#### Playbooks

Playbooks are YML files defining what roles to run on a group of hosts.

```shell
# bootstrappers.yml
---
- hosts: bootstrappers
  become: yes
  remote_user: "{{ deploy_user }}"
  roles:
    - role: ssh-keys
      ssh_user: "{{ deploy_user }}"
    - role: geerlingguy.docker
      docker_install_compose: false
    - role: python-dependencies
    - role: nginx_conf_bootstrappers
    - role: node_exporter
      version: "v0.18.1"
    - role: go-ipfs-deploy-docker
  vars_files:
    - ../secrets_secure/vault.yml
```

#### Variables and secrets
Variables that apply to all hosts in an inventory are stored in `inventories/<hosts_group>/group_vars/all.yml`  while host-specific vars should go in `inventories/<hosts_group>/hosts_vars/hostname.fqdn.yml`


Secrets are stored in `secrets_secure/vault.yml` which is basically an encrypted YAML file containing var definitions. The vault file needs to be specified in the playbook definition under `var_files` in order for Ansible to read variables from it. A vault password also needs to be specified at run-time either via `--vault-password-file` or `--ask-vault-pass`.

In order to edit the vault, run: `ansible-vault edit secrets_secure/vault.yml`

The password can be found in 1Password under `Ansible vault password`


To run an entire playbook on all hosts in a group:
```shell
ansible-playbook -i inventories/bootstrappers/hosts -v --vault-password-file=./vault_password bootstrappers.yml
```

Use `--limit hostname.fqdn` to run an entire playbook on a specific host in a group:
```shell
ansible-playbook -i inventories/bootstrappers/hosts -v --vault-password-file=./vault_password --limit neptune.i.ipfs.io bootstrappers.yml
```
