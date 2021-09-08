FROM golang:1.16-alpine AS builder

LABEL maintainer="Sean Macdonald <sean.macdonald@rmp.uhn.ca>" \
    ca.uhn.techna.version="0.6.0" \
    ca.uhn.techna.project="rds" \
    ca.uhn.techna.app="torus" \
    ca.uhn.techna.container="tusd" \
    ca.uhn.techna.role="tusd"

ENV REPO_LOCATION=github.com/sean9999/tusd

#   Copy source
COPY . /go/src/$REPO_LOCATION
WORKDIR /go/src/$REPO_LOCATION

#   Build from source
RUN apk add --no-cache gcc libc-dev
ENV GOOS=linux GOARCH=amd64
RUN go build \
    -ldflags="-X github.com/tus/tusd/cmd/tusd/cli.VersionName=${BEAUTIFUL_BRANCH} -X github.com/tus/tusd/cmd/tusd/cli.GitCommit=${GIT_REF} -X 'github.com/tus/tusd/cmd/tusd/cli.BuildDate=$(date --utc)'" \
    -o "/go/bin/tusd" ./cmd/tusd/main.go

#   copy built binary to fresh container
FROM alpine:3.13

COPY --from=builder /go/bin/tusd /usr/local/bin/tusd

RUN apk add --no-cache ca-certificates jq gcc \
    && addgroup -g 1000 tusd \
    && adduser -u 1000 -G tusd -s /bin/sh -D tusd \
    && mkdir -p /srv/tusd-hooks \
    && mkdir -p /srv/tusd-data \
    && chown tusd:tusd /srv/tusd-data

WORKDIR /srv/tusd-data
EXPOSE 1080
ENTRYPOINT ["tusd"]

USER tusd
