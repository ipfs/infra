ARG GO_IPFS_VERSION
FROM go-ipfs-ansible:$GO_IPFS_VERSION

RUN wget -q -O /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 \
  && chmod +x /usr/local/bin/jq
COPY container_daemon /usr/local/bin/start_ipfs
