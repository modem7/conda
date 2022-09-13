#!/usr/bin/env bash

set -euo pipefail

# System envs
GITDIR='/tensorflow/tensorflow/lite/tools/pip_package'
DEBIAN_FRONTEND=noninteractive

# Update apt
apt-get update

# Install basic packages
apt-get install -y --no-install-recommends \
                     curl \
                     git \
                     unzip

# Clone git repo
git -c advice.detachedHead=false clone --depth 1 --branch $TENSORFLOWVER https://github.com/tensorflow/tensorflow.git

# Download required apt packages
apt-get install -y --no-install-recommends \
                     build-essential \
                     debhelper \
                     pybind11-dev \
                     zlib1g-dev &
# Install supplemental python packages
python3 -m pip install -U pybind11 &
python3 -m pip install -U numpy==1.19.2 &
# Start downloading tensorflow dependencies whilst we wait for everything else to install to save some time
bash tensorflow/tensorflow/lite/tools/make/download_dependencies.sh &
wait

# Create output directory
mkdir -p $OUTDIR

# Clone git repo
# git -c advice.detachedHead=false clone --depth 1 --branch $TENSORFLOWVER https://github.com/tensorflow/tensorflow.git

# Install supplemental python packages
# https://itecnote.com/tecnote/python-parallel-pip-install/
# cat << EOF | xargs --max-args=1 --max-procs=4 python3 -m pip install -U
# pip
# wheel
# setuptools
# EOF

# cat << EOF | xargs --max-args=1 --max-procs=4 python3 -m pip install -U
# pybind11
# numpy
# EOF

# Build and export tflite wheel
$GITDIR/build_pip_package.sh && \
                   (cp $GITDIR/gen/tflite_pip/$PYTHON/dist/*.whl \
                       $OUTDIR 2>/dev/null || true)

# Fixing wheel dir permissions as container is run as root
chown -R $PUID:$PGID $OUTDIR