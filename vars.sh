#!/bin/bash

# shellcheck disable=SC2034
VERSION="$CHART_VERSION"
GIT_REF="$(git rev-parse @)"
GIT_BRANCH="$(git name-rev --name-only $GIT_REF | grep --color=no -E -o '\w+$')"
BEAUTIFUL_BRANCH=${GIT_BRANCH/*\//}
BEAUTIFUL_BRANCH=${BEAUTIFUL_BRANCH//[[:punct:]]/}

source .env

AWS_ACCESS_KEY_ID=$ECS_USER_ID
AWS_SECRET_ACCESS_KEY=$ECS_SECRET_KEY
AWS_REGION=ca-central-1

DOCKER_CONTAINER_NAME=rds-torus-tusd-localdev

function is_running() {
  docker container inspect -f '{{.State.Running}}' $DOCKER_CONTAINER_NAME
}
