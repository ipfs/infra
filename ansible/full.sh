#!/bin/sh

hosts="$1"
[ -z "$hosts" ] && hosts="all"

ansible-playbook -l "$hosts" common.yml  || exit 1
ansible-playbook -l "$hosts" cjdns.yml   || exit 1
ansible-playbook -l "$hosts" metrics.yml || exit 1
ansible-playbook -l "$hosts" pinbot.yml  || exit 1
ansible-playbook -l "$hosts" users.yml   || exit 1
