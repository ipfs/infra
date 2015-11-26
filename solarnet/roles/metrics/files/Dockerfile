FROM golang:1.4
MAINTAINER lars@ipfs.io

ENV GOPATH=/go \
    REPO_PATH=github.com/prometheus/prometheus
COPY src/ /go/src/$REPO_PATH

RUN cd /go/src/$REPO_PATH \
    && cp -a ./Godeps/_workspace/src/* "$GOPATH/src/" \
    && go build -ldflags " \
            -X main.buildVersion  $(cat version/VERSION) \
            -X main.buildRevision $(git rev-parse --short HEAD) \
            -X main.buildBranch   $(git rev-parse --abbrev-ref HEAD) \
            -X main.buildUser     root \
            -X main.buildDate     $(date +%Y%m%d-%H:%M:%S) \
            -X main.goVersion     $(go version | awk '{print substr($3,3)}') \
        " -o /bin/prometheus $REPO_PATH/cmd/prometheus \
    && mkdir -p /etc/prometheus /prometheus \
    && rm -rf /go

EXPOSE     9090
VOLUME     [ "/prometheus", "/etc/prometheus" ]
WORKDIR    /prometheus
ENTRYPOINT [ "/bin/prometheus" ]
CMD        [ "-config.file=/etc/prometheus/prometheus.yml", \
             "-storage.local.path=/prometheus", \
             "-storage.local.memory-chunks=512288", \
             "-storage.local.retention=8760h0m0s", \
             "-web.path-prefix=/prometheus", \
             "-web.console.libraries=/etc/prometheus/console_libraries", \
             "-web.console.templates=/etc/prometheus/consoles" ]
