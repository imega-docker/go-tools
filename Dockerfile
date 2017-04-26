FROM golang:1.8-alpine

RUN apk add --update --no-cache bash git && \
    go get golang.org/x/tools/cmd/goimports && \
    go get -u github.com/golang/dep/... && \
    go get -u github.com/kisielk/errcheck

COPY ./run.sh /

ENTRYPOINT ["/run.sh"]
