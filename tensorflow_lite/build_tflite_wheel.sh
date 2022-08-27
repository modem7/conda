#!/usr/bin/env bash

set -euo pipefail

echo "### Initialising wheel build..."

# Global Envs
SECONDS="0"
IMGNAME="python:3.7-slim-bullseye"

# System Envs
export PUID=$(id -u)
export PGID=$(id -g)
export TENSORFLOWVER='v2.4.1'
export TENSORFLOW_TARGET='native'
export PYTHON='python3.7'
export OUTDIR='/data/wheel/tflite'

docker run --rm -it --init -v "$(pwd)":/data -e TENSORFLOWVER -e PUID -e PGID -e OUTDIR -e PYTHON -e TENSORFLOW_TARGET $IMGNAME /bin/bash -c "/data/env_scripts/build_tflite_wheel.sh"

echo -e "\n###################"
date -ud "@$SECONDS" "+Time taken to build TFLite wheel: %H:%M:%S"
echo "###################"
echo "Wheel location: $(pwd)/out/"
echo -e "###################\n"

exit 0
