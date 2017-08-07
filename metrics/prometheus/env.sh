#!/usr/bin/env bash

all_prometheus_git="https://github.com/prometheus/prometheus.git"
all_prometheus_ref="3afb3fffa3a29c3de865e1172fb740442e9d0133"

all_prometheus_opts=("-storage.local.memory-chunks=512288"
                     "-storage.local.retention=43800h0m0s"
                     "-web.external-url=http://metrics.ipfs.team/prometheus")

all_prometheus_scrape_interval="15s"
all_prometheus_scrape_timeout="10s"
all_prometheus_evaluation_interval="15s"

all_prometheus_gateway_hosts=(pluto neptune uranus saturn jupiter venus earth mercury scrappy chappy)
all_prometheus_storage_hosts=(pollux biham nihal auva)
all_prometheus_metrics_hosts=(banana)
all_prometheus_probe_hosts=(banana deimos)
all_prometheus_jenkins_hosts=(jenkins)
all_prometheus_all_hosts=${provsn_hosts[@]}
