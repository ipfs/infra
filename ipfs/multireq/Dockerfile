FROM golang:1.5.3
MAINTAINER Lars Gierth <larsg@systemli.org>

ADD . /go/src/github.com/whyrusleeping/multireq

RUN cd /go/src/github.com/whyrusleeping/multireq && go get -d && go install && rm -rf /go/src/github.com

ENTRYPOINT ["multireq"]
