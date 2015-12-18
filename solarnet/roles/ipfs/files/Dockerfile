FROM golang:1.5.2
MAINTAINER Lars Gierth <larsg@systemli.org>

# This IPFS repo should be copied into ./go-ipfs
ADD . /go/src/github.com/ipfs/go-ipfs

RUN cd /go/src/github.com/ipfs/go-ipfs && make install

# clean up the image to keep it small
RUN rm -rf /go/src/github.com

EXPOSE 8080 4001 4002/udp 5001

WORKDIR /ipfs
CMD ["ipfs daemon"]
