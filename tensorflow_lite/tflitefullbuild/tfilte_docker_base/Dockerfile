# syntax = docker/dockerfile-upstream:master-labs

ARG CONDAENV='tensorflow'
ARG PYTHONENV='3.7'
ARG TENSORFLOWDIR='tensorflow_src/tensorflow/lite/tools'

###############
# tflite-builder

FROM condaforge/mambaforge-pypy3:4.13.0-1 as tflite-builder

# System Env
# ENV PIP_ROOT_USER_ACTION='ignore'
# ENV PYTHONDONTWRITEBYTECODE='1'
# ENV PYTHONUNBUFFERED='1'
ENV DEBIAN_FRONTEND=noninteractive

# User Env
ENV TENSORFLOWVER='2.4.1'
ENV CONDARC='/opt/conda/.condarc'
ARG CONDAENV
ARG PYTHONENV
ARG TENSORFLOWDIR

ADD --link --keep-git-dir=false https://github.com/tensorflow/tensorflow.git#v$TENSORFLOWVER /tensorflow_src

RUN rm -f /etc/apt/apt.conf.d/docker-clean

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    <<EOF
    set -x
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
    apt-get update
    DEBIAN_FRONTEND=noninteractive
    apt-get install -y build-essential curl libjpeg-dev swig unzip zip zlib1g-dev python$PYTHONENV-dev python3-numpy
EOF

RUN --mount=type=cache,id=$CONDAENV,target=/opt/conda/pkgs,sharing=locked \
    --mount=type=cache,target=/root/.cache/pip \
    <<EOF
    set -x
    cat > $CONDARC << CON
channels:
  - anaconda
  - defaults
CON
    mamba create --name $CONDAENV -y python=$PYTHONENV
    mamba init bash
    . ~/.bashrc
    . activate $CONDAENV
    python3 -m pip install -U pybind11 numpy pillow
    $TENSORFLOWDIR/make/download_dependencies.sh
    PYTHON=python$PYTHONENV $TENSORFLOWDIR/pip_package/build_pip_package.sh
EOF

###############
# envbuild

FROM condaforge/mambaforge-pypy3:4.13.0-1 AS envbuild

# System Env
# ENV PIP_ROOT_USER_ACTION='ignore'
# ENV PYTHONDONTWRITEBYTECODE='1'
# ENV PYTHONUNBUFFERED='1'

# User Env
ARG CONDAENV
ARG PYTHONENV
ARG TENSORFLOWDIR
ENV ENVFILE='environment_aggregate.yml'

# Install the package as normal and any packages in /wheel dir:
COPY --link $ENVFILE /wheel/*.whl /
COPY --link --from=tflite-builder /$TENSORFLOWDIR/pip_package/gen/tflite_pip/python$PYTHONENV/dist/tflite_runtime-*.whl /

RUN --mount=type=cache,id=$CONDAENV,target=/opt/conda/pkgs,sharing=locked \
    <<EOF
    set -x
    mamba env create -v -f $ENVFILE 
    mamba run -n $CONDAENV python3 -m pip install --no-cache *.whl
    # Use conda-pack to create a standalone environment in /venv
    mamba install -y -c anaconda conda-pack
    conda-pack -j -1 -n $CONDAENV -o /tmp/env.tar
    mkdir /venv && cd /venv
    tar xf /tmp/env.tar
    rm /tmp/env.tar
    # We've put venv in same path it'll be in final image, so now fix up paths
    /venv/bin/conda-unpack
EOF

###############

# The runtime-stage image; we can use Debian as the
# base image since the Conda env also includes Python
# for us.
FROM debian:bullseye-slim AS runtime

# Copy entrypoint script
COPY --link --chmod=755 entrypoint.sh /entrypoint.sh

# Copy /venv from the previous stage:
COPY --link --from=envbuild /venv /venv

# When image is run, run the code with the environment activated:
SHELL ["/bin/bash", "-c"]

#ENTRYPOINT ["/venv/bin/tini", "-g", "--"]
CMD ["/entrypoint.sh"]