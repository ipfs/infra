---
global:
  scrape_interval:     $(var prometheus_scrape_interval)
  scrape_timeout:      $(var prometheus_scrape_timeout)
  evaluation_interval: $(var prometheus_evaluation_interval)

scrape_configs:

  - job_name: 'gateway'
    metrics_path: '/debug/metrics/prometheus'
    static_configs:
$(for h in $(lookup prometheus_gateway_hosts); do
  echo   '      - targets:'
  printf '        - "[%s]:5001"\n' $(host=$h var cjdns_ipv6)
  echo   '        labels:'
  printf '          host: %s\n' $h
  echo   '          network: v04x'
done)

  - job_name: 'bootstrap'
    metrics_path: '/debug/metrics/prometheus'
    static_configs:
$(for h in $(lookup prometheus_bootstrap_hosts); do
  echo   '      - targets:'
  printf '        - "[%s]:5001"\n' $(host=$h var cjdns_ipv6)
  echo   '        labels:'
  printf '          host: %s\n' $h
  echo   '          network: v04x'
done)

  - job_name: 'jenkins'
    metrics_path: '/prometheus/'
    honor_labels: false
    static_configs:
$(for h in $(lookup prometheus_jenkins_hosts); do
  echo   '      - targets:'
  printf '        - "[%s]:8090"\n' $(host=$h var cjdns_ipv6)
  echo   '        labels:'
  printf '          host: %s\n' $h
done)

  - job_name: 'storage'
    metrics_path: '/debug/metrics/prometheus'
    static_configs:
$(for h in $(lookup prometheus_storage_hosts); do
  echo   '      - targets:'
  printf '        - "[%s]:5001"\n' $(host=$h var cjdns_ipv6)
  echo   '        labels:'
  printf '          host: %s\n' $h
  echo   '          network: v04x'
done)

  - job_name: 'mtail'
    metrics_path: '/metrics'
    static_configs:
$(for h in $(lookup prometheus_all_hosts); do
  echo   '      - targets:'
  printf '        - "[%s]:3903"\n' $(host=$h var cjdns_ipv6)
  echo   '        labels:'
  printf '          host: %s\n' $h
done)
    metric_relabel_configs:
      - source_labels: [prog]
        regex: .*
        action: replace
        target_label: prog
      - source_labels: [exported_instance]
        regex: .*
        action: replace
        target_label: exported_instance

  - job_name: 'host'
    metrics_path: '/metrics'
    static_configs:
$(for h in $(lookup prometheus_all_hosts); do
  echo   '      - targets:'
  printf '        - "[%s]:9100"\n' $(host=$h var cjdns_ipv6)
  echo   '        labels:'
  printf '          host: %s\n' $h
done)

  - job_name: 'blackbox'
    metrics_path: '/metrics'
    static_configs:
$(for h in $(lookup prometheus_all_hosts); do
  echo   '      - targets:'
  printf '        - "[%s]:9115"\n' $(host=$h var cjdns_ipv6)
  echo   '        labels:'
  printf '          host: %s\n' $h
done)
    metric_relabel_configs:
      - source_labels: [handler]
        regex: .*
        action: replace
        target_label: handler

  - job_name: 'prometheus'
    metrics_path: '/prometheus/metrics'
    static_configs:
$(for h in $(lookup prometheus_metrics_hosts); do
  echo   '      - targets:'
  printf '        - "[%s]:80"\n' $(host=$h var cjdns_ipv6)
  echo   '        labels:'
  printf '          host: %s\n' $h
done)

$(for dest in $(lookup prometheus_gateway_hosts); do
  printf '  - job_name: pages_ipfs_io_%s\n' $dest
  echo   '    metrics_path: /probe'
  echo   '    params:'
  echo   '      module: [ipfs_io]'
  printf '      target: [%s.i.ipfs.io]\n' $dest
  echo   '    static_configs:'
  for src in $(lookup prometheus_probe_hosts); do
    echo   '      - targets:'
    printf '        - "[%s]:9115"\n' $(host=$src var cjdns_ipv6)
    echo   '        labels:'
    printf '          host: %s\n' $dest
    printf '          prober: %s\n' $src
    echo   '          page: ipfs.io'
  done
done)

$(for dest in $(lookup prometheus_gateway_hosts); do
  printf '  - job_name: pages_multiformats_io_%s\n' $dest
  echo   '    metrics_path: /probe'
  echo   '    params:'
  echo   '      module: [multiformats_io]'
  printf '      target: [%s.i.ipfs.io]\n' $dest
  echo   '    static_configs:'
  for src in $(lookup prometheus_probe_hosts); do
    echo   '      - targets:'
    printf '        - "[%s]:9115"\n' $(host=$src var cjdns_ipv6)
    echo   '        labels:'
    printf '          host: %s\n' $dest
    printf '          prober: %s\n' $src
    echo   '          page: multiformats.io'
  done
done)

$(for dest in $(lookup prometheus_gateway_hosts); do
  printf '  - job_name: pages_ipld_io_%s\n' $dest
  echo   '    metrics_path: /probe'
  echo   '    params:'
  echo   '      module: [ipld_io]'
  printf '      target: [%s.i.ipfs.io]\n' $dest
  echo   '    static_configs:'
  for src in $(lookup prometheus_probe_hosts); do
    echo   '      - targets:'
    printf '        - "[%s]:9115"\n' $(host=$src var cjdns_ipv6)
    echo   '        labels:'
    printf '          host: %s\n' $dest
    printf '          prober: %s\n' $src
    echo   '          page: ipld.io'
  done
done)

$(for dest in $(lookup prometheus_gateway_hosts); do
  printf '  - job_name: pages_libp2p_io_%s\n' $dest
  echo   '    metrics_path: /probe'
  echo   '    params:'
  echo   '      module: [libp2p_io]'
  printf '      target: [%s.i.ipfs.io]\n' $dest
  echo   '    static_configs:'
  for src in $(lookup prometheus_probe_hosts); do
    echo   '      - targets:'
    printf '        - "[%s]:9115"\n' $(host=$src var cjdns_ipv6)
    echo   '        labels:'
    printf '          host: %s\n' $dest
    printf '          prober: %s\n' $src
    echo   '          page: libp2p.io'
  done
done)

  - job_name: mailchimp_filecoin
    metrics_path: $(var prometheus_mailchimp_path)
    basic_auth:
      username: $(var prometheus_mailchimp_user)
      password: $(var prometheus_mailchimp_password)
    scheme: https
    static_configs:
      - targets:
        - $(var prometheus_mailchimp_target)

  - job_name: libp2pstats
    metrics_path: $(var prometheus_libp2pstats_path)
    basic_auth:
      username: $(var prometheus_libp2pstats_user)
      password: $(var prometheus_libp2pstats_password)
    scheme: http
    static_configs:
      - targets:
        - $(var prometheus_libp2pstats_target)
