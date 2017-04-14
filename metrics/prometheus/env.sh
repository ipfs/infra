#!/usr/bin/env bash

all_prometheus_git="https://github.com/prometheus/prometheus.git"
all_prometheus_ref="36fbdcc30fd13ad796381dc934742c559feeb1b5"

all_prometheus_opts=("-storage.local.memory-chunks=512288"
                     "-storage.local.retention=8760h0m0s"
                     "-web.external-url=http://metrics.ipfs.team/prometheus")

all_prometheus_scrape_interval="15s"
all_prometheus_scrape_timeout="10s"
all_prometheus_evaluation_interval="15s"

all_prometheus_gateway_hosts=(pluto neptune uranus saturn jupiter venus earth mercury)
all_prometheus_storage_hosts=(pollux biham nihal auva)
all_prometheus_metrics_hosts=(banana)
all_prometheus_probe_hosts=(banana deimos)
all_prometheus_jenkins_hosts=(jenkins)
all_prometheus_all_hosts=${provsn_hosts[@]}
