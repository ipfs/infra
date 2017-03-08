#!/usr/bin/env bash

set -eo pipefail; [[ $SCRIPT_TRACE ]] && set -x

# Collects go-ipfs debug info and publishes it.
#
# Usage:
#
#   > scp scripts/ipfs-debug.sh root@spacerock.i.ipfs.io:/root/
#   > ssh root@spacerock.i.ipfs.io /root/ipfs-debug.sh
#   ...
#   https://ipfs.io/ipfs/QmTzqwxh2kjSQznZh8iYZzeXtQuHZ9pDkocxu184mKJqxd
#

cmd="$1"
[ "$cmd" ] || cmd="docker exec -i ipfs ipfs"

echo "curl localhost:5001/debug/pprof/goroutine?debug=2 | ipfs add --pin=false"
hash1=$(curl -s 'localhost:5001/debug/pprof/goroutine?debug=2' | $cmd add --pin=false -q 2>/dev/null)
echo "==> https://ipfs.io/ipfs/$hash1"
echo
echo "curl localhost:5001/debug/pprof/heap | ipfs add --pin=false"
hash2=$(curl -s 'localhost:5001/debug/pprof/heap'              | $cmd add --pin=false -q 2>/dev/null)
echo "==> https://ipfs.io/ipfs/$hash2"
echo
echo "curl localhost:5001/api/v0/diag/sys | ipfs add --pin=false"
hash3=$(curl -s 'localhost:5001/api/v0/diag/sys' | jq .        | $cmd add --pin=false -q 2>/dev/null)
echo "==> https://ipfs.io/ipfs/$hash3"
echo
echo "cat /usr/local/bin/ipfs | ipfs add --pin=false"
hash4=$($cmd add --pin=false -q /usr/local/bin/ipfs 2>/dev/null)
echo "==> https://ipfs.io/ipfs/$hash4"
echo
echo "curl localhost:5001/debug/pprof/profile | ipfs add --pin=false"
hash5=$(curl -s 'localhost:5001/debug/pprof/profile'           | $cmd add --pin=false -q 2>/dev/null)
echo "==> https://ipfs.io/ipfs/$hash5"
echo

dir0="QmUNLLsPACCz1vLxQVkXqqLX5R1X345qqfHbsf67hvA3Nn"
dir1=$($cmd object patch add-link "$dir0" ipfs.stacks "$hash1" 2>/dev/null)
dir2=$($cmd object patch add-link "$dir1" ipfs.heap "$hash2" 2>/dev/null)
dir3=$($cmd object patch add-link "$dir2" ipfs.sysinfo "$hash3" 2>/dev/null)
dir4=$($cmd object patch add-link "$dir3" ipfs "$hash4" 2>/dev/null)
dir5=$($cmd object patch add-link "$dir4" ipfs.cpuprof "$hash5" 2>/dev/null)

echo "http://localhost:8080/ipfs/$dir5"
echo "https://ipfs.io/ipfs/$dir5"
echo "fs:/ipfs/$dir5"
