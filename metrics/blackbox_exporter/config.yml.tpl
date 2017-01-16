---
modules:
$(for name in $(var blackbox_exporter_probers); do
  printf '  %s:\n' $name
  echo   '    prober: http'
  echo   '    timeout: 5s'
  echo   '    http:'
  echo   '      valid_status_codes: []  # Defaults to 2xx'
  echo   '      method: GET'
  echo   '      headers:'
  printf '        Host: %s\n' $(var blackbox_exporter_probers_$name)
  echo   '        Accept-Language: en-US'
  echo   '      no_follow_redirects: false'
  echo   '      fail_if_ssl: false'
  echo   '      fail_if_not_ssl: false'
  echo   '      tls_config:'
  echo   '        insecure_skip_verify: false'
done)
  tcp_connect:
    prober: tcp
    timeout: 5s
  icmp:
    prober: icmp
    timeout: 5s
