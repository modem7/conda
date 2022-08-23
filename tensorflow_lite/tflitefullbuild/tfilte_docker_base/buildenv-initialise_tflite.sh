#!/usr/bin/env bash

set -e

echo "### Initialising dep build..."
echo "### Please be patient, this can take 15-20 minutes..."

# Global Envs
SECONDS="0"
IMGNAME="condaforge/mambaforge-pypy3:4.13.0-1"
export CONDAENV="tensorflow"
export PYTHONENV="3.7"
export CONDARC="/opt/conda/.condarc"
VOLUME=CONDACACHE

# Image Specific Envs
# ML
export CONDAREQSTF="/data/env_scripts/dependencies_tfl.txt"
export ENVFILETF="/data/environment_tfl.yml"

exec docker run --rm -v $VOLUME:/opt/conda/pkgs:cached -v "$(pwd)":/data -e CONDAENV -e PYTHONENV -e CONDARC -e CONDAREQSTF -e ENVFILETF $IMGNAME /bin/bash -c "/data/env_scripts/buildenv_tfl.sh"

echo ""
echo "###################"
date -ud "@$SECONDS" "+Time taken to build TFLite environment: %H:%M:%S"
echo "###################"
echo "You can remove the conda cache with: 'docker volume rm $VOLUME'. It will be recreated at next run."
echo "###################"

exit 0
