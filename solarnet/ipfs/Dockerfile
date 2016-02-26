FROM golang:1.5.3
MAINTAINER Lars Gierth <larsg@systemli.org>

# This IPFS repo should be copied into ./go-ipfs
ADD . /go/src/github.com/ipfs/go-ipfs

RUN cd /go/src/github.com/ipfs/go-ipfs && make install && rm -rf /go/src/github.com

EXPOSE 8080 4001 4002/udp 5001

ENV IPFS_PATH=/data/ipfs IPFS_LOGGING=debug IPFS_PROF=true

WORKDIR /data/ipfs
CMD ["ipfs", "daemon", "--enable-gc"]
