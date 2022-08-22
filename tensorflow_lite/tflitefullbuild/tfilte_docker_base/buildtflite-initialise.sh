#!/bin/bash

set -e

# Requirements:
# git clone --depth 1 --branch v2.4.1 https://github.com/tensorflow/tensorflow.git

echo "### Initialising dep build..."

# Global Envs
SECONDS=0
IMAGE=debian:buster-slim
GIT_DIR=$(pwd)
PYTHON=python3.7
TENSORFLOW_TARGET=native # (empty or native)
OUT_DIR=wheel
TENSORFLOW_DIR=tensorflow
APT_INSTALL="apt-get update && apt-get install -y debhelper dh-python pybind11-dev python3-all python3-setuptools python3-wheel python3-numpy python3-pip libpython3-dev zlib1g-dev curl unzip git"
PIP_INSTALL="python3 -m pip install -U pip && python3 -m pip install -U pybind11"

echo "Making directory"
mkdir -p $OUT_DIR

echo "Running image"
docker run \
    --rm -it \
    -e PYTHON="$PYTHON" \
    -e TENSORFLOW_TARGET="$TENSORFLOW_TARGET" \
    -v "$GIT_DIR/$TENSORFLOW_DIR":/tensorflow \
    -v "$GIT_DIR/$OUT_DIR":/out \
     $IMAGE /bin/bash -c "$APT_INSTALL && $PIP_INSTALL && /tensorflow/tensorflow/lite/tools/pip_package/build_pip_package.sh && \
                         (cp /tensorflow/tensorflow/lite/tools/pip_package/gen/tflite_pip/*.deb \
                         /tensorflow/tensorflow/lite/tools/pip_package/gen/tflite_pip/${PYTHON}/dist/{*.whl,*.tar.gz} \
                        /out 2>/dev/null || true)"

echo ""
echo "###################"
echo "Deleting tar files"
rm -vf "$GIT_DIR/$OUT_DIR"/*.gz
echo "###################"

echo ""
echo "###################"
date -ud "@$SECONDS" "+Time taken to build TFLite: %H:%M:%S"
echo "###################"

exit 0