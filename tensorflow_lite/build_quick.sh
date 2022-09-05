#!/usr/bin/env bash

set -euo pipefail

echo "### Initialising Tensorflow Docker image build..."

# Global Envs
SECONDS='0'
IMGNAME='conda'
IMGTAG='test'
DOCKERFILE='Dockerfile_quick'
export DOCKER_BUILDKIT=1

docker build --build-arg BUILDKIT_INLINE_CACHE=1 -t $IMGNAME:$IMGTAG -f $DOCKERFILE .

echo -e "\n###################"
date -ud "@$SECONDS" "+Time taken to build TFLite Docker base image: %H:%M:%S"
echo -e "###################\n"

exit 0
