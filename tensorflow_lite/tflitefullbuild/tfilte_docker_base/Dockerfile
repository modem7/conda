# syntax = docker/dockerfile-upstream:master-labs

ARG CONDAENV='tensorflow'
ARG PYTHONENV='3.7'
ARG TENSORFLOWDIR='tensorflow'
ARG GITDIR='/tensorflow/tensorflow/lite/tools'

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
ENV TENSORFLOW_TARGET='native'
ENV PYTHON='python3.7'
ARG CONDAENV
ARG PYTHONENV
ARG TENSORFLOWDIR
ARG GITDIR

ADD --link --keep-git-dir=false https://github.com/tensorflow/tensorflow.git#v$TENSORFLOWVER /tensorflow
COPY --link $GITDIR/make/downloads/ $GITDIR/make/downloads/

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    <<EOF
    set -x
    rm -f /etc/apt/apt.conf.d/docker-clean
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
    apt-get update
    DEBIAN_FRONTEND=noninteractive
    apt-get install -y debhelper dh-python pybind11-dev python3-all python3-setuptools python3-wheel python3-numpy python3-pip libpython3-dev zlib1g-dev curl unzip git
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
    $GITDIR/pip_package/build_pip_package.sh
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
ARG GITDIR

# Install the package as normal and any packages in /wheel dir:
COPY --link $ENVFILE /wheel/*.whl /
COPY --link --from=tflite-builder $GITDIR/pip_package/gen/tflite_pip/python$PYTHONENV/dist/tflite_runtime-*.whl /

RUN --mount=type=cache,id=$CONDAENV,target=/opt/conda/pkgs,sharing=locked \
    <<EOF
    set -x
    mamba env create -v conda_package_handling pybind11 -f $ENVFILE 
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
FROM debian:buster-slim AS runtime

# Copy entrypoint script
COPY --link --chmod=755 entrypoint.sh /entrypoint.sh

# Copy /venv from the previous stage:
COPY --link --from=envbuild /venv /venv

# When image is run, run the code with the environment activated:
SHELL ["/bin/bash", "-c"]

#ENTRYPOINT ["/venv/bin/tini", "-g", "--"]
CMD ["/entrypoint.sh"]