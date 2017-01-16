export GOROOT=/usr/local/go
export GOPATH="$HOME/go"
echo $PATH | grep $GOPATH >/dev/null || export PATH="$GOPATH/bin:$PATH"
export GOBIN="$GOPATH/bin"
echo $PATH | grep $GOROOT >/dev/null || export PATH="$GOROOT/bin:$PATH"
