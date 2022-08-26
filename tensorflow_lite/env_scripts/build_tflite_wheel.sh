#!/usr/bin/env bash

set -euo pipefail

# System envs
GITDIR='/tensorflow/tensorflow/lite/tools/pip_package'
DEBIAN_FRONTEND=noninteractive
PIP_ROOT_USER_ACTION='ignore'

# Update apt and download required packages
apt-get update
apt-get install -y --no-install-recommends \
                   build-essential \
                   curl \
                   debhelper \
                   dh-python \
                   git \
                   libpython3-dev \
                   pybind11-dev \
                   python3-all \
                   python3-numpy \
                   python3-pip \
                   python3-setuptools \
                   python3-wheel \
                   unzip \
                   zlib1g-dev

# Create output directory
mkdir -p $OUTDIR

# Clone git repo
git -c advice.detachedHead=false clone --depth 1 --branch $TENSORFLOWVER https://github.com/tensorflow/tensorflow.git

# Install supplemental python packages
python3 -m pip install -U pybind11

# Build and export tflite wheel
$GITDIR/build_pip_package.sh && \
                   (cp $GITDIR/gen/tflite_pip/$PYTHON/dist/*.whl \
                       $OUTDIR 2>/dev/null || true)

# Fixing wheel dir permissions as container is run as root
chown -R $PUID:$PGID $OUTDIR