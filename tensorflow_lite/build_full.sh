#!/usr/bin/env bash

set -euo pipefail

echo "### Initialising environment build..."
# Global Envs
SECONDS='0'
IMGNAME='condaforge/mambaforge:4.13.0-1'
export CONDAENV='tensorflow'
export PYTHONENV='3.7'
export CONDARC='/opt/conda/.condarc'
VOLUME='CONDACACHE'

# Image Specific Envs
# Aggregate
export CONDAREQSCONNECT="/data/env_scripts/dependencies_connect.txt"
export CONDAREQSDEPLOY="/data/env_scripts/dependencies_deploy.txt"
export CONDAREQSML="/data/env_scripts/dependencies_ml.txt"
export CONDAREQSTF="/data/env_scripts/dependencies_tfl.txt"
export ENVFILEAGG="/data/environment_aggregate.yml"

docker run --rm -v $VOLUME:/opt/conda/pkgs:cached -v "$(pwd)":/data -e CONDAENV -e PYTHONENV -e CONDARC -e CONDAREQSCONNECT -e CONDAREQSDEPLOY -e CONDAREQSML -e CONDAREQSTF -e ENVFILEAGG $IMGNAME /bin/bash -c "/data/env_scripts/buildenv_aggregate.sh"

echo "### Initialising Tensorflow light wheel build..."

# Global Envs
IMGNAME="python:3.7-slim-bullseye"

# System Envs
export PUID=$(id -u)
export PGID=$(id -g)
export TENSORFLOWVER='v2.4.1'
export TENSORFLOW_TARGET='native'
export PYTHON='python3.7'
export OUTDIR='/data/wheel/tflite'

docker run --rm -it --init -v "$(pwd)":/data -e TENSORFLOWVER -e PUID -e PGID -e OUTDIR -e PYTHON -e TENSORFLOW_TARGET $IMGNAME /bin/bash -c "/data/env_scripts/build_tflite_wheel.sh"

echo "### Initialising Tensorflow Docker image build..."

IMAGENAME='conda'
IMAGETAG='test'
DOCKER_BUILDKIT='1'
DOCKERFILE='Dockerfile_quick'

docker build --build-arg BUILDKIT_INLINE_CACHE=1 -t $IMAGENAME:$IMAGETAG -f $DOCKERFILE .

echo -e "\n###################"
date -ud "@$SECONDS" "+Time taken to build TFLite image: %H:%M:%S"
echo -e "###################\n"

exit 0
