#!/usr/bin/env bash

set -e

mkdir -p out/
provsn_template nginx.conf.tpl out/nginx.conf

printf %s\\n "$(lookup pages_orbit_ssl_cert)" > out/orbit.chat.crt
printf %s\\n "$(lookup pages_orbit_ssl_key)" > out/orbit.chat.key
printf %s\\n "$(lookup pages_orbit_ssl_trustchain)" > out/orbit.chat.trustchain.crt
printf %s\\n "$(lookup pages_orbit_ssl_dhparam)" > out/orbit.chat.dhparam.pem

printf %s\\n "$(lookup pages_bootstrap_ssl_cert)" > out/bootstrap.libp2p.io.crt
printf %s\\n "$(lookup pages_bootstrap_ssl_key)" > out/bootstrap.libp2p.io.key
printf %s\\n "$(lookup pages_bootstrap_ssl_trustchain)" > out/bootstrap.libp2p.io.trustchain.crt
printf %s\\n "$(lookup pages_bootstrap_ssl_dhparam)" > out/bootstrap.libp2p.io.dhparam.pem

printf %s\\n "$(lookup pages_ipld_ssl_cert)" > out/ipld.io.crt
printf %s\\n "$(lookup pages_ipld_ssl_key)" > out/ipld.io.key
printf %s\\n "$(lookup pages_ipld_ssl_trustchain)" > out/ipld.io.trustchain.crt
printf %s\\n "$(lookup pages_ipld_ssl_dhparam)" > out/ipld.io.dhparam.pem

printf %s\\n "$(lookup pages_libp2p_ssl_cert)" > out/libp2p.io.crt
printf %s\\n "$(lookup pages_libp2p_ssl_key)" > out/libp2p.io.key
printf %s\\n "$(lookup pages_libp2p_ssl_trustchain)" > out/libp2p.io.trustchain.crt
printf %s\\n "$(lookup pages_libp2p_ssl_dhparam)" > out/libp2p.io.dhparam.pem

printf %s\\n "$(lookup pages_multiformats_ssl_cert)" > out/multiformats.io.crt
printf %s\\n "$(lookup pages_multiformats_ssl_key)" > out/multiformats.io.key
printf %s\\n "$(lookup pages_multiformats_ssl_trustchain)" > out/multiformats.io.trustchain.crt
printf %s\\n "$(lookup pages_multiformats_ssl_dhparam)" > out/multiformats.io.dhparam.pem

printf %s\\n "$(lookup pages_zcash_dag_ssl_cert)" > out/zcash.dag.ipfs.io.crt
printf %s\\n "$(lookup pages_zcash_dag_ssl_key)" > out/zcash.dag.ipfs.io.key
printf %s\\n "$(lookup pages_zcash_dag_ssl_trustchain)" > out/zcash.dag.ipfs.io.trustchain.crt
printf %s\\n "$(lookup pages_zcash_dag_ssl_dhparam)" > out/zcash.dag.ipfs.io.dhparam.pem

printf %s\\n "$(lookup pages_protocol_ssl_cert)" > out/protocol.ai.crt
printf %s\\n "$(lookup pages_protocol_ssl_key)" > out/protocol.ai.key
printf %s\\n "$(lookup pages_protocol_ssl_trustchain)" > out/protocol.ai.trustchain.crt
printf %s\\n "$(lookup pages_protocol_ssl_dhparam)" > out/protocol.ai.dhparam.pem
