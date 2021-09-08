#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck source=../vars.sh
source $DIR/../vars.sh
# shellcheck source=./vars.sh
source $DIR/vars.sh

echo "running tusd..."

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export AWS_REGION

docker run --name=$DOCKER_CONTAINER_NAME --rm \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -e AWS_REGION \
  --network=host \
  "${TUSD_CONTAINER_IMAGE_LOCATION}:$GIT_REF" \
  -s3-bucket="$ECS_BUCKET_NAME" \
  -s3-endpoint="$ECS_ENDPOINT" \
  -s3-part-size="$FILE_CHUNK_SIZE"

exit 0

docker run --name=$DOCKER_CONTAINER_NAME --rm \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -e AWS_REGION \
  --network=host \
  "${TUSD_CONTAINER_IMAGE_LOCATION}:$GIT_REF" \
  -s3-bucket="$ECS_BUCKET_NAME" \
  -s3-endpoint="$ECS_ENDPOINT" \
  -s3-part-size="$FILE_CHUNK_SIZE" \
  -s3-object-prefix="$ECS_BUCKET_NAMESPACE" \
  -hooks-http=http://$RESTSERVER_URL:$RESTSERVER_PORT/v$RESTSERVER_VERSION/assets/tusMessage
