#!/usr/bin/env bash

# Small test suite ensuring Public HTTP Gateway behaves correctly,
# all CORS headers and permissions are in place etc.
#
# Originally created to catch regressions similar to:
# https://github.com/ipfs-shipyard/ipfs-share-files/issues/17#issuecomment-416766663
#
# Usage:
#   ./public-gateway-smoke-test.sh <domain>
#
# Example:
#   ./public-gateway-smoke-test.sh gateway.ipfs.io
#
# Dependencies:
# - bash
# - curl
#

# fail fast
trap 'echo "Error on line $LINENO"' ERR

fqdn="${1:-ipfs.io}"

defaultOpts="-s -m 30"
printHeaders="-D -"
ignoreBody="-o /dev/null"

function  report () {
    code=$?
    if [ $code -eq 0 ]; then
        printf OK
    else
        echo FAIL
        exit $code
    fi
}

echo "==> Running a bunch of HTTP requests to $1 to see if it follows requirements of Public Gateway.."

printf "\n--> Testing /ipfs/ .."

# ensure X-Ipfs-Path header is returned

printf "\nGET CIDv0: "
emptyDirUrl="https://$fqdn/ipfs/QmUNLLsPACCz1vLxQVkXqqLX5R1X345qqfHbsf67hvA3Nn"
emptyDirHeaders=$(curl $defaultOpts $printHeaders $ignoreBody "$emptyDirUrl")
report

printf "\nGET CIDv1: "
pngUrl="https://$fqdn/ipfs/bafybeifzrnergk3bw4xl3di57s4vrjwta47gsedcnvpfqf45ztmullxz6i/distributed-architecture-of-ipfs.png"
pngHeaders=$(curl $defaultOpts $printHeaders $ignoreBody "$pngUrl")
report

printf "\nX-Ipfs-Path[HEAD]: "
curl $defaultOpts -I "$pngUrl" | grep -qF "X-Ipfs-Path: /ipfs/bafybeifzrnergk3bw4xl3di57s4vrjwta47gsedcnvpfqf45ztmullxz6i/distributed-architecture-of-ipfs.png"
report

printf "\nX-Ipfs-Path[GET]: "
grep -qF "X-Ipfs-Path: /ipfs/QmUNLLsPACCz1vLxQVkXqqLX5R1X345qqfHbsf67hvA3Nn" <<< $emptyDirHeaders
report

printf "\nEtag: "
grep -qF 'Etag: "QmUNLLsPACCz1vLxQVkXqqLX5R1X345qqfHbsf67hvA3Nn"' <<< $emptyDirHeaders
report

printf "\nAccess-Control-Allow-Origin[*]: "
grep -qF 'Access-Control-Allow-Origin: *' <<< $emptyDirHeaders
report

printf "\nAccess-Control-Allow-Headers: "
grep -qF 'Access-Control-Allow-Headers: ' <<< $emptyDirHeaders
report
printf "\nAccess-Control-Allow-Headers[Content-Range]: "
(grep -F 'Access-Control-Allow-Headers: ' | grep -qF 'Content-Range') <<< $emptyDirHeaders
report
printf "\nAccess-Control-Allow-Headers[X-Chunked-Output]: "
(grep -F 'Access-Control-Allow-Headers: ' | grep -qF 'X-Chunked-Output') <<< $emptyDirHeaders
report
printf "\nAccess-Control-Allow-Headers[X-Stream-Output]: "
(grep -F 'Access-Control-Allow-Headers: ' | grep -qF 'X-Stream-Output') <<< $emptyDirHeaders
report
printf "\nAccess-Control-Allow-Methods[GET]: "
(grep -F 'Access-Control-Allow-Methods' | grep -qF 'GET') <<< $emptyDirHeaders
report
printf "\nAccess-Control-Expose-Headers: "
grep -qF 'Access-Control-Expose-Headers: ' <<< $emptyDirHeaders
report
printf "\nAccess-Control-Expose-Headers[Content-Range]: "
(grep -F 'Access-Control-Expose-Headers: ' | grep -qF 'Content-Range') <<< $emptyDirHeaders
report
printf "\nAccess-Control-Expose-Headers[X-Chunked-Output]: "
(grep -F 'Access-Control-Expose-Headers: ' | grep -qF 'X-Chunked-Output') <<< $emptyDirHeaders
report
printf "\nAccess-Control-Expose-Headers[X-Stream-Output]: "
(grep -F 'Access-Control-Expose-Headers: ' | grep -qF 'X-Stream-Output') <<< $emptyDirHeaders
report

printf "\n\n--> Testing /api/v0/ ..\n"

# regression test for https://github.com/ipfs-shipyard/ipfs-share-files/issues/17#issuecomment-416766663
ipfsLs="https://$fqdn/api/v0/ls?arg=QmbWqxBEKC3P8tqsKc98xmWNzrzDtRLMiMPL8wBuTGsMnR"
ipfsLsExpected='{"Objects":[{"Hash":"QmbWqxBEKC3P8tqsKc98xmWNzrzDtRLMiMPL8wBuTGsMnR","Links":[]}]}'

printf "\nplain curl GET: "
curl $defaultOpts $ipfsLs | grep -qF $ipfsLsExpected
report

printf "\nlocal CORS fetch: "
curl $defaultOpts $ipfsLs  -H 'Origin: https://localhost:3000/' -H 'Referer: http://localhost:3000/'   | grep -qF $ipfsLsExpected
report

printf "\nremote CORS fetch: "
curl $defaultOpts $ipfsLs  -H 'Origin: https://wikipedia.org/'  -H 'Referer: https://wikipedia.org/'   | grep -qF $ipfsLsExpected
report

printf "\n\n==> If you can see this then all went well and $fqdn passed the smoke test :-)\n"
