{
  "cluster": {
    "id": "$(var ipfs_cluster_peerid)",
    "private_key": "$(var ipfs_cluster_private_key)",
    "secret": "$(var ipfs_cluster_secret)",
    "peers": [
      "/dns4/pluto.i.ipfs.team/tcp/9096/ipfs/QmSiW1LpXRzbkuhjSABTJBJd9zb5vckVofbTFLjH5fmrM5",
      "/dns4/neptune.i.ipfs.team/tcp/9096/ipfs/QmQBriDc5ZNAHdYzC9gAZ17s1eJvenp5SUzHnZMv65pnJH",
      "/dns4/uranus.i.ipfs.team/tcp/9096/ipfs/QmQEn69dRXLENMaV33f2MRAqNg4u1GwzjisWr4ewQ4B974",
      "/dns4/saturn.i.ipfs.team/tcp/9096/ipfs/QmNWGCZe8StGiJ6G4HKqmB3YkMVPoQvbPqE6yo8paQddVP",
      "/dns4/jupiter.i.ipfs.team/tcp/9096/ipfs/QmTVCTKnCueMz95ifXC81jQZyX9e43cDT9AXnGcjd71XoU",
      "/dns4/venus.i.ipfs.team/tcp/9096/ipfs/QmQfpaSGNkXtMHD3UyLUUWcaKquT4hA1h42wcPxZXtXdeT",
      "/dns4/earth.i.ipfs.team/tcp/9096/ipfs/QmWZEJm76A7v8qBXKQcFKcGFA982Qwhzz6zZMakRMoVWZo",
      "/dns4/mercury.i.ipfs.team/tcp/9096/ipfs/QmUpZtr7MhrkZCZRPjG3xoL4ocpy1v1JNuvnhnfv5mGhYs",
      "/dns4/scrappy.i.ipfs.team/tcp/9096/ipfs/QmRjdKMdQbvhjiXVncoC9pdouFoJcxRxXy78Ucd2XdnoSS",
      "/dns4/chappy.i.ipfs.team/tcp/9096/ipfs/QmXYzjACnh4yZPYcm93TJLcFLh4MdBJCN3tK7uVMnLCmPQ"
    ],
    "bootstrap": [],
    "leave_on_shutdown": false,
    "listen_multiaddress": "/ip4/0.0.0.0/tcp/9096",
    "state_sync_interval": "2m0s",
    "ipfs_sync_interval": "5m",
    "replication_factor": -1,
    "monitor_ping_interval": "45s"
  },
  "consensus": {
    "raft": {
      "wait_for_leader_timeout": "25s",
      "network_timeout": "10s",
      "commit_retries": 1,
      "commit_retry_delay": "500ms",
      "heartbeat_timeout": "2s",
      "election_timeout": "2s",
      "commit_timeout": "100ms",
      "max_append_entries": 256,
      "trailing_logs": 10240,
      "snapshot_interval": "5m0s",
      "snapshot_threshold": 8192,
      "leader_lease_timeout": "1000ms"
    }
  },
  "api": {
    "restapi": {
      "listen_multiaddress": "/ip4/127.0.0.1/tcp/9094",
      "read_timeout": "60s",
      "read_header_timeout": "5s",
      "write_timeout": "1m0s",
      "idle_timeout": "2m0s",
      "basic_auth_credentials": null
    }
  },
  "ipfs_connector": {
    "ipfshttp": {
      "proxy_listen_multiaddress": "/ip4/127.0.0.1/tcp/9095",
      "node_multiaddress": "/ip4/127.0.0.1/tcp/5001",
      "connect_swarms_delay": "30s",
      "proxy_read_timeout": "10m0s",
      "proxy_read_header_timeout": "5s",
      "proxy_write_timeout": "10m0s",
      "proxy_idle_timeout": "1m0s"
    }
  },
  "pin_tracker": {
    "maptracker": {
      "pinning_timeout": "1h0m0s",
      "unpinning_timeout": "5m0s",
      "max_pin_queue_size": 4096
    }
  },
  "monitor": {
    "monbasic": {
      "check_interval": "180s"
    }
  },
  "informer": {
    "disk": {
      "metric_ttl": "1200s",
      "metric_type": "freespace"
    },
    "numpin": {
      "metric_ttl": "10s"
    }
  }
}
