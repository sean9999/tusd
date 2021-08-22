#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck source=../vars.sh
source $DIR/../vars.sh
# shellcheck source=./vars.sh
source $DIR/vars.sh

echo "building tusd..."

docker build \
	-t ${TUSD_CONTAINER_IMAGE_LOCATION} \
	-t ${TUSD_CONTAINER_IMAGE_LOCATION}:$GIT_REF \
	-t ${TUSD_CONTAINER_IMAGE_LOCATION}:$BEAUTIFUL_BRANCH \
	--label ca.uhn.techna.org="$ORG" \
	--label ca.uhn.techna.project="$PROJECT" \
	--label ca.uhn.techna.app="$CHART_NAME" \
	--label ca.uhn.techna.version="$CHART_VERSION" \
	--label ca.uhn.techna.container="tusd" \
	--label ca.uhn.techna.role="tusd" \
	$DIR
