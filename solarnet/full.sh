#!/bin/sh

hosts="$1"
[ -z "$hosts" ] && hosts="all"

ansible-playbook -l "$hosts" common.yml
ansible-playbook -l "$hosts" ipfs.yml
ansible-playbook -l "$hosts" gateway.yml
ansible-playbook -l "$hosts" metrics.yml
ansible-playbook -l "$hosts" pinbot.yml
