{
  "Identity": {
    "PeerID": "$(var ipfs_peerid)",
    "PrivKey": "$(var ipfs_private_key)"
  },
  "Datastore": {
    "BloomFilterSize": $(var ipfs_bloom_size),
    "NoSync": true,
    "HashOnRead": false,
    "GCPeriod": "$(var ipfs_gc_period)",
    "StorageGCWatermark": $(var ipfs_gc_watermark),
    "StorageMax": "$(var ipfs_gc_capacity)",
    "Spec": "XXX this will be overwritten by install.sh"
  },
  "Experimental": {
    "ShardingEnabled": $(var ipfs_enable_sharding)
  },
  "Addresses": {
    "Swarm": [
      "/ip4/0.0.0.0/tcp/$(var ipfs_swarm_tcp)",
      "/ip6/::/tcp/$(var ipfs_swarm_tcp)",
      "/ip4/127.0.0.1/tcp/$(var ipfs_swarm_ws)/ws"
    ],
    "API": "/ip4/127.0.0.1/tcp/$(var ipfs_api)",
    "Gateway": "/ip4/127.0.0.1/tcp/$(var ipfs_gateway)"
  },
  "Mounts": {
    "IPFS": "/ipfs",
    "IPNS": "/ipns",
    "FuseAllowOther": false
  },
  "Discovery": {
    "MDNS": {
      "Enabled": false,
      "Interval": 10
    }
  },
  "Bootstrap": [
    "/dnsaddr/bootstrap.libp2p.io/ipfs/QmNnooDu7bfjPFoTZYxMNLWUQJyrVwtbZg5gBMjTezGAJN",
    "/dnsaddr/bootstrap.libp2p.io/ipfs/QmQCU2EcMqAqQPR2i9bChDtGNJchTbq5TbXJJ16u19uLTa",
    "/dnsaddr/bootstrap.libp2p.io/ipfs/QmbLHAnMoJPWSCR5Zhtx6BHJX9KiKNN6tpvbUcqanj75Nb",
    "/dnsaddr/bootstrap.libp2p.io/ipfs/QmcZf59bWwK5XFi76CZX8cbJ4BhTzzA3gU1ZjYZcYW3dwt",
    "/ip4/104.131.131.82/tcp/4001/ipfs/QmaCpDMGvV2BGHeYERUEnRQAwe3N8SzbUtfsmvsqQLuvuJ",
    "/ip4/104.236.179.241/tcp/4001/ipfs/QmSoLPppuBtQSGwKDZT2M73ULpjvfd3aZ6ha4oFGL1KrGM",
    "/ip4/128.199.219.111/tcp/4001/ipfs/QmSoLSafTMBsPKadTEgaXctDQVcqN88CNLHXMkTNwMKPnu",
    "/ip4/104.236.76.40/tcp/4001/ipfs/QmSoLV4Bbm51jM9C4gDYZQ9Cy3U6aXMJDAbzgu2fzaDs64",
    "/ip4/178.62.158.247/tcp/4001/ipfs/QmSoLer265NRgSp2LA3dPaeykiS1J6DifTC88f5uVQKNAd",
    "/ip6/2604:a880:1:20::203:d001/tcp/4001/ipfs/QmSoLPppuBtQSGwKDZT2M73ULpjvfd3aZ6ha4oFGL1KrGM",
    "/ip6/2400:6180:0:d0::151:6001/tcp/4001/ipfs/QmSoLSafTMBsPKadTEgaXctDQVcqN88CNLHXMkTNwMKPnu",
    "/ip6/2604:a880:800:10::4a:5001/tcp/4001/ipfs/QmSoLV4Bbm51jM9C4gDYZQ9Cy3U6aXMJDAbzgu2fzaDs64",
    "/ip6/2a03:b0c0:0:1010::23:1001/tcp/4001/ipfs/QmSoLer265NRgSp2LA3dPaeykiS1J6DifTC88f5uVQKNAd"
  ],
  "Gateway": {
    "PathPrefixes": ["/blog", "/refs"],
    "RootRedirect": "",
    "Writable": false,
    "HTTPHeaders": {
      "Access-Control-Allow-Origin": ["*"],
      "Access-Control-Allow-Methods": ["GET"],
      "Access-Control-Allow-Headers": ["X-Requested-With", "Range"]
    }
  },
  "API": {
    "HTTPHeaders": {
      "Access-Control-Allow-Origin": [
        "*"
      ]
    }
  },
  "DialBlocklist": null,
  "Swarm": {
    "DisableRelay": false,
    "EnableRelayHop": true,
    "DisableBandwidthMetrics": true,
    "DisableNatPortMap": true,
    "AddrFilters": [
$(for h in ${provsn_hosts[@]}; do
  printf '      "/ip6/%s/ipcidr/128",\n' $(host=$h var cjdns_ipv6)
done)
      "/ip4/10.0.0.0/ipcidr/8",
      "/ip4/100.64.0.0/ipcidr/10",
      "/ip4/169.254.0.0/ipcidr/16",
      "/ip4/172.16.0.0/ipcidr/12",
      "/ip4/192.0.0.0/ipcidr/24",
      "/ip4/192.0.0.0/ipcidr/29",
      "/ip4/192.0.0.8/ipcidr/32",
      "/ip4/192.0.0.170/ipcidr/32",
      "/ip4/192.0.0.171/ipcidr/32",
      "/ip4/192.0.2.0/ipcidr/24",
      "/ip4/192.168.0.0/ipcidr/16",
      "/ip4/198.18.0.0/ipcidr/15",
      "/ip4/198.51.100.0/ipcidr/24",
      "/ip4/203.0.113.0/ipcidr/24",
      "/ip4/240.0.0.0/ipcidr/4"
    ],
    "ConnMgr": {
      "GracePeriod": "$(var ipfs_connmgr_period)",
      "HighWater": $(var ipfs_connmgr_highwater),
      "LowWater": $(var ipfs_connmgr_lowwater),
      "Type": "$(var ipfs_connmgr_type)"
    }
  }
}
