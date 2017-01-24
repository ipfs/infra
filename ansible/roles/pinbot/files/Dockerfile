FROM golang:1.7.4
MAINTAINER Lars Gierth <larsg@systemli.org>

ENV GOPATH=/go \
    REPO_PATH=github.com/whyrusleeping/pinbot
COPY . $GOPATH/src/$REPO_PATH

RUN go get github.com/whyrusleeping/hellabot \
    && go get github.com/whyrusleeping/ipfs-shell \
    && cd $GOPATH/src/$REPO_PATH \
    && go build -o /bin/pinbot $REPO_PATH

VOLUME     [ "/pinbot" ]
WORKDIR    /pinbot
ENTRYPOINT [ "/bin/pinbot" ]
CMD        [  ]

# XXX pending this fix: https://github.com/ansible/ansible-modules-core/pull/2258
EXPOSE 12345
