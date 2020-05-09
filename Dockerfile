FROM golang:1.14-alpine as b

MAINTAINER siddontang

RUN apk add --no-cache git

ADD . /go/src/github.com/siddontang/go-mysql-elasticsearch
WORKDIR /go/src/github.com/siddontang/go-mysql-elasticsearch

RUN GO111MODULE=on go build -o bin/go-mysql-elasticsearch ./cmd/go-mysql-elasticsearch

FROM alpine:3.11

RUN apk add --no-cache tini mariadb-client

COPY --from=b /go/src/github.com/siddontang/go-mysql-elasticsearch/bin/go-mysql-elasticsearch /go-mysql-elasticsearch

ENTRYPOINT ["/sbin/tini", "--", "/go-mysql-elasticsearch"]
