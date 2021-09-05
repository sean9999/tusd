FROM golang:1.16-alpine AS builder

LABEL maintainer="Sean Macdonald <sean.macdonald@rmp.uhn.ca>" \
    ca.uhn.techna.version="0.6.0" \
    ca.uhn.techna.project="rds" \
    ca.uhn.techna.app="torus" \
    ca.uhn.techna.container="tusd" \
    ca.uhn.techna.role="tusd"

# Copy in the git repo from the build context
COPY . /go/src/github.com/sean9999/tusd/

# Create app directory
WORKDIR /go/src/github.com/sean9999/tusd

RUN apk add --no-cache \
        git gcc libc-dev \
    && go get -d -v ./... \
    && version="$(git tag -l --points-at HEAD)" \
    && commit=$(git log --format="%H" -n 1) \
    && GOOS=linux GOARCH=amd64 go build \
        -ldflags="-X github.com/tus/tusd/cmd/tusd/cli.VersionName=${version} -X github.com/tus/tusd/cmd/tusd/cli.GitCommit=${commit} -X 'github.com/tus/tusd/cmd/tusd/cli.BuildDate=$(date --utc)'" \
        -o "/go/bin/tusd" ./cmd/tusd/main.go \
    && rm -r /go/src/* \
    && apk del git

# start a new stage that copies in the binary built in the previous stage
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
