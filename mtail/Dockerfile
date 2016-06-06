FROM alpine:3.3
MAINTAINER Lars Gierth <lgierth@ipfs.io>

EXPOSE 3903

ENV GO_VERSION 1.5.4-r0
ENV GOPATH     /go
ENV PATH       /go/bin:$PATH
ENV SRC_PATH   /go/src/github.com/google/mtail
ENV PROGS_PATH /mtail/progs
ENV LOGS_PATH  /mtail/logs

RUN apk add --update musl go=$GO_VERSION git bash make
COPY . $SRC_PATH
RUN mkdir -p $PROGS_PATH $LOGS_PATH \
  && adduser -D -h /mtail -u 1000 mtail \
  && chown mtail:mtail /mtail && chmod 755 /mtail \
  && cd $SRC_PATH && rm -f .dep-stamp && make \
  && mv `which mtail` /usr/local/bin/mtail \
  && apk del --purge musl go git && rm -rf $GOPATH

USER mtail
VOLUME $PROGS_PATH
VOLUME $LOGS_PATH
WORKDIR $LOGS_PATH
ENTRYPOINT ["/usr/local/bin/mtail", "-v=2", "-logtostderr", "-port", "3903", "-progs", "/mtail/progs", "-logs"]
