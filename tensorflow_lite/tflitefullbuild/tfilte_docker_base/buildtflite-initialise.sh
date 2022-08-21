#!/usr/bin/env bash

set -e

# Requirements:
# git clone --depth 1 --branch v2.4.1 https://github.com/tensorflow/tensorflow.git

echo "### Initialising dep build..."

# Global Envs
SECONDS="0"
TAG_IMAGE="debian:buster"
USER="$(id -u)"
GROUP="$(id -g)"
PYTHON=python3.7
TENSORFLOW_TARGET=native # (empty or native)
OUT_DIR="$(pwd)/wheel"
TENSORFLOW_DIR="$(pwd)/tensorflow"

mkdir -p $(OUT_DIR)
docker run --user $USER:$GROUP \
	--rm --interactive $(shell tty -s && echo --tty) \
	--env "PYTHON=$(PYTHON)" \
	--env "TENSORFLOW_TARGET=$(TENSORFLOW_TARGET)" \
	--volume $(TENSORFLOW_DIR):/tensorflow \
	--volume $(OUT_DIR):/out \
	$(TAG_IMAGE) \
	/bin/bash -c "/tensorflow/tensorflow/lite/tools/pip_package/build_pip_package.sh && \
	              (cp /tensorflow/tensorflow/lite/tools/pip_package/gen/tflite_pip/*.deb \
	                  /tensorflow/tensorflow/lite/tools/pip_package/gen/tflite_pip/${PYTHON}/dist/{*.whl,*.tar.gz} \
	                  /out 2>/dev/null || true)"

echo ""
echo "###################"
date -ud "@$SECONDS" "+Time taken to build ML environment: %H:%M:%S"
echo "###################"
echo "You can remove the conda cache with: 'docker volume rm $VOLUME'. It will be recreated at next run."
echo "###################"

exit 0
