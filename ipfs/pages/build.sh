#!/usr/bin/env bash

set -e

mkdir -p out/
provsn_template nginx.conf.tpl out/nginx.conf

printf %s\\n "$(lookup pages_iipfs_ssl_cert)" > out/i.ipfs.io.crt
printf %s\\n "$(lookup pages_iipfs_ssl_key)" > out/i.ipfs.io.key
printf %s\\n "$(lookup pages_iipfs_ssl_trustchain)" > out/i.ipfs.io.trustchain.crt
printf %s\\n "$(lookup pages_iipfs_ssl_dhparam)" > out/i.ipfs.io.dhparam.pem

printf %s\\n "$(lookup pages_betadocsipfs_ssl_cert)" > out/beta.docs.ipfs.io.crt
printf %s\\n "$(lookup pages_betadocsipfs_ssl_key)" > out/beta.docs.ipfs.io.key
printf %s\\n "$(lookup pages_betadocsipfs_ssl_trustchain)" > out/beta.docs.ipfs.io.trustchain.crt
printf %s\\n "$(lookup pages_betadocsipfs_ssl_dhparam)" > out/beta.docs.ipfs.io.dhparam.pem

printf %s\\n "$(lookup pages_filecoin_ssl_cert)" > out/filecoin.io.crt
printf %s\\n "$(lookup pages_filecoin_ssl_key)" > out/filecoin.io.key
printf %s\\n "$(lookup pages_filecoin_ssl_trustchain)" > out/filecoin.io.trustchain.crt
printf %s\\n "$(lookup pages_filecoin_ssl_dhparam)" > out/filecoin.io.dhparam.pem

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

printf %s\\n "$(lookup pages_wikipediaonipfs_ssl_cert)" > out/wikipedia-on-ipfs.org.crt
printf %s\\n "$(lookup pages_wikipediaonipfs_ssl_key)" > out/wikipedia-on-ipfs.org.key
printf %s\\n "$(lookup pages_wikipediaonipfs_ssl_trustchain)" > out/wikipedia-on-ipfs.org.trustchain.crt
printf %s\\n "$(lookup pages_wikipediaonipfs_ssl_dhparam)" > out/wikipedia-on-ipfs.org.dhparam.pem

printf %s\\n "$(lookup pages_en_wikipediaonipfs_ssl_cert)" > out/en.wikipedia-on-ipfs.org.crt
printf %s\\n "$(lookup pages_en_wikipediaonipfs_ssl_key)" > out/en.wikipedia-on-ipfs.org.key
printf %s\\n "$(lookup pages_en_wikipediaonipfs_ssl_trustchain)" > out/en.wikipedia-on-ipfs.org.trustchain.crt
printf %s\\n "$(lookup pages_en_wikipediaonipfs_ssl_dhparam)" > out/en.wikipedia-on-ipfs.org.dhparam.pem

printf %s\\n "$(lookup pages_tr_wikipediaonipfs_ssl_cert)" > out/tr.wikipedia-on-ipfs.org.crt
printf %s\\n "$(lookup pages_tr_wikipediaonipfs_ssl_key)" > out/tr.wikipedia-on-ipfs.org.key
printf %s\\n "$(lookup pages_tr_wikipediaonipfs_ssl_trustchain)" > out/tr.wikipedia-on-ipfs.org.trustchain.crt
printf %s\\n "$(lookup pages_tr_wikipediaonipfs_ssl_dhparam)" > out/tr.wikipedia-on-ipfs.org.dhparam.pem

printf %s\\n "$(lookup pages_simple_wikipediaonipfs_ssl_cert)" > out/simple.wikipedia-on-ipfs.org.crt
printf %s\\n "$(lookup pages_simple_wikipediaonipfs_ssl_key)" > out/simple.wikipedia-on-ipfs.org.key
printf %s\\n "$(lookup pages_simple_wikipediaonipfs_ssl_trustchain)" > out/simple.wikipedia-on-ipfs.org.trustchain.crt
printf %s\\n "$(lookup pages_simple_wikipediaonipfs_ssl_dhparam)" > out/simple.wikipedia-on-ipfs.org.dhparam.pem

printf %s\\n "$(lookup pages_ar_wikipediaonipfs_ssl_cert)" > out/ar.wikipedia-on-ipfs.org.crt
printf %s\\n "$(lookup pages_ar_wikipediaonipfs_ssl_key)" > out/ar.wikipedia-on-ipfs.org.key
printf %s\\n "$(lookup pages_ar_wikipediaonipfs_ssl_trustchain)" > out/ar.wikipedia-on-ipfs.org.trustchain.crt
printf %s\\n "$(lookup pages_ar_wikipediaonipfs_ssl_dhparam)" > out/ar.wikipedia-on-ipfs.org.dhparam.pem

printf %s\\n "$(lookup pages_ku_wikipediaonipfs_ssl_cert)" > out/ku.wikipedia-on-ipfs.org.crt
printf %s\\n "$(lookup pages_ku_wikipediaonipfs_ssl_key)" > out/ku.wikipedia-on-ipfs.org.key
printf %s\\n "$(lookup pages_ku_wikipediaonipfs_ssl_trustchain)" > out/ku.wikipedia-on-ipfs.org.trustchain.crt
printf %s\\n "$(lookup pages_ku_wikipediaonipfs_ssl_dhparam)" > out/ku.wikipedia-on-ipfs.org.dhparam.pem

printf %s\\n "$(lookup pages_datatogether_ssl_cert)" > out/datatogether.org.crt
printf %s\\n "$(lookup pages_datatogether_ssl_key)" > out/datatogether.org.key
printf %s\\n "$(lookup pages_datatogether_ssl_trustchain)" > out/datatogether.org.trustchain.crt
printf %s\\n "$(lookup pages_datatogether_ssl_dhparam)" > out/datatogether.org.dhparam.pem

printf %s\\n "$(lookup pages_saftprojectcom_ssl_cert)" > out/saftproject.com.crt
printf %s\\n "$(lookup pages_saftprojectcom_ssl_key)" > out/saftproject.com.key
printf %s\\n "$(lookup pages_saftprojectcom_ssl_trustchain)" > out/saftproject.com.trustchain.crt
printf %s\\n "$(lookup pages_saftprojectcom_ssl_dhparam)" > out/saftproject.com.dhparam.pem

printf %s\\n "$(lookup pages_wwwsaftprojectcom_ssl_cert)" > out/www.saftproject.com.crt
printf %s\\n "$(lookup pages_wwwsaftprojectcom_ssl_key)" > out/www.saftproject.com.key
printf %s\\n "$(lookup pages_wwwsaftprojectcom_ssl_trustchain)" > out/www.saftproject.com.trustchain.crt
printf %s\\n "$(lookup pages_wwwsaftprojectcom_ssl_dhparam)" > out/www.saftproject.com.dhparam.pem

printf %s\\n "$(lookup pages_saft_projectcom_ssl_cert)" > out/saft-project.com.crt
printf %s\\n "$(lookup pages_saft_projectcom_ssl_key)" > out/saft-project.com.key
printf %s\\n "$(lookup pages_saft_projectcom_ssl_trustchain)" > out/saft-project.com.trustchain.crt
printf %s\\n "$(lookup pages_saft_projectcom_ssl_dhparam)" > out/saft-project.com.dhparam.pem

printf %s\\n "$(lookup pages_wwwsaft_projectcom_ssl_cert)" > out/www.saft-project.com.crt
printf %s\\n "$(lookup pages_wwwsaft_projectcom_ssl_key)" > out/www.saft-project.com.key
printf %s\\n "$(lookup pages_wwwsaft_projectcom_ssl_trustchain)" > out/www.saft-project.com.trustchain.crt
printf %s\\n "$(lookup pages_wwwsaft_projectcom_ssl_dhparam)" > out/www.saft-project.com.dhparam.pem

printf %s\\n "$(lookup pages_saft_projectorg_ssl_cert)" > out/saft-project.org.crt
printf %s\\n "$(lookup pages_saft_projectorg_ssl_key)" > out/saft-project.org.key
printf %s\\n "$(lookup pages_saft_projectorg_ssl_trustchain)" > out/saft-project.org.trustchain.crt
printf %s\\n "$(lookup pages_saft_projectorg_ssl_dhparam)" > out/saft-project.org.dhparam.pem

printf %s\\n "$(lookup pages_wwwsaft_projectorg_ssl_cert)" > out/www.saft-project.org.crt
printf %s\\n "$(lookup pages_wwwsaft_projectorg_ssl_key)" > out/www.saft-project.org.key
printf %s\\n "$(lookup pages_wwwsaft_projectorg_ssl_trustchain)" > out/www.saft-project.org.trustchain.crt
printf %s\\n "$(lookup pages_wwwsaft_projectorg_ssl_dhparam)" > out/www.saft-project.org.dhparam.pem

printf %s\\n "$(lookup pages_peerpad_ssl_cert)" > out/peerpad.net.crt
printf %s\\n "$(lookup pages_peerpad_ssl_key)" > out/peerpad.net.key
printf %s\\n "$(lookup pages_peerpad_ssl_trustchain)" > out/peerpad.net.trustchain.crt
printf %s\\n "$(lookup pages_peerpad_ssl_dhparam)" > out/peerpad.net.dhparam.pem

printf %s\\n "$(lookup pages_flipchart_ssl_cert)" > out/flipchart.peerpad.net.crt
printf %s\\n "$(lookup pages_flipchart_ssl_key)" > out/flipchart.peerpad.net.key
printf %s\\n "$(lookup pages_flipchart_ssl_trustchain)" > out/flipchart.peerpad.net.trustchain.crt
printf %s\\n "$(lookup pages_flipchart_ssl_dhparam)" > out/flipchart.peerpad.net.dhparam.pem
