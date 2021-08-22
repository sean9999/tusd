#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck source=../vars.sh
source "$DIR/../vars.sh"
# shellcheck source=./vars.sh
source $DIR/vars.sh

echo "pushing tusd..."
docker push ${TUSD_CONTAINER_IMAGE_LOCATION}:latest
docker push ${TUSD_CONTAINER_IMAGE_LOCATION}:$GIT_REF
docker push ${TUSD_CONTAINER_IMAGE_LOCATION}:$BEAUTIFUL_BRANCH
