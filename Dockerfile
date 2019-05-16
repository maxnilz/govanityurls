FROM golang:1.12.1-alpine3.9 as builder

RUN apk add --no-cache --update alpine-sdk bash
ENV GO111MODULE "on"
COPY . /go/src/github.com/maxnilz/govanityurls
RUN cd /go/src/github.com/maxnilz/govanityurls && go build -o govanityurls

FROM alpine:3.9

RUN apk add --update tzdata ca-certificates openssl && rm -rf /var/cache/apk/*

COPY --from=builder /go/src/github.com/maxnilz/govanityurls/govanityurls /usr/local/bin/govanityurls
COPY --from=builder /go/src/github.com/maxnilz/govanityurls/vanity.yaml /etc/vanity.yaml

WORKDIR /

ENTRYPOINT ["govanityurls", "/etc/vanity.yaml"]