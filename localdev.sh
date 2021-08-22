#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck source=../vars.sh
source $DIR/../vars.sh
# shellcheck source=./vars.sh
source $DIR/vars.sh

echo "running tusd..."

#AWS_ACCESS_KEY_ID=$ECS_USER_ID
#AWS_SECRET_ACCESS_KEY=$ECS_SECRET_KEY
#AWS_REGION=ca-central-1

##  @note: we are sending -s3-object-prefix for future compatibility (supporting namespaces)
##  which will be necessary if we want to support more than one instance of RDS

docker run -p 1080:1080 "${TUSD_CONTAINER_IMAGE_LOCATION}:$GIT_REF" \
  -s3-bucket="$ECS_BUCKET_NAME" \
  -s3-endpoint="$ECS_ENDPOINT" \
  -s3-part-size="$FILE_CHUNK_SIZE" \
  -s3-object-prefix="$ECS_BUCKET_NAMESPACE"
