FROM golang:1.22-alpine AS base

RUN apk add --no-cache git
WORKDIR /usr/local/src
RUN git clone https://github.com/iandennismiller/bitcoind-exporter.git
WORKDIR /usr/local/src/bitcoind-exporter

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux 

RUN go mod download

FROM base as build

RUN go build -o bitcoind-exporter -tags prod version.go main.go

FROM scratch as prod

COPY --from=build /usr/local/src/bitcoind-exporter/bitcoind-exporter /

WORKDIR /
ENTRYPOINT ["/bitcoind-exporter"]
