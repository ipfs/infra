FROM alpine:3.2
MAINTAINER Lars Gierth <larsg@systemli.org>

ENV GOPATH=/go \
    REPO_PATH=github.com/whyrusleeping/pinbot
COPY . $GOPATH/src/$REPO_PATH

RUN apk add --update go git \
    && apk add -u musl \
    && go get github.com/whyrusleeping/hellabot \
    && go get github.com/whyrusleeping/ipfs-shell \
    && cd $GOPATH/src/$REPO_PATH \
    && go build -o /bin/pinbot $REPO_PATH \
    && rm -rf $GOPATH /var/cache/apk/* \
    && apk del --purge go git

VOLUME     [ "/pinbot" ]
WORKDIR    /pinbot
ENTRYPOINT [ "/bin/pinbot" ]
CMD        [  ]
