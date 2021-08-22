#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck source=../vars.sh
source $DIR/../vars.sh
# shellcheck source=./vars.sh
source $DIR/vars.sh

echo "running tusd..."

AWS_ACCESS_KEY_ID=$ECS_USER_ID
AWS_SECRET_ACCESS_KEY=$ECS_SECRET_KEY
AWS_REGION=ca-central-1

docker run ${TUSD_CONTAINER_IMAGE_LOCATION}:$GIT_REF -help

