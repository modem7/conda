#!/usr/bin/env bash

set -e

echo "### Initialising dep build..."
echo "### Please be patient, this can take 15-20 minutes..."

# Global Envs
SECONDS="0"
IMGNAME="condaforge/mambaforge:4.13.0-1"
export CONDAENV="tensorflow"
export PYTHONENV="3.7"
export CONDARC="/opt/conda/.condarc"
VOLUME=CONDACACHE

# Image Specific Envs
# ML
export CONDAREQSCHILLER="/data/env_scripts/dependencies_chiller.txt"
export ENVFILECHILLER="/data/environment_chiller.yml"

exec docker run --rm -v $VOLUME:/opt/conda/pkgs:cached -v "$(pwd)":/data -e CONDAENV -e PYTHONENV -e CONDARC -e CONDAREQSCHILLER -e ENVFILECHILLER $IMGNAME /bin/bash -c "/data/env_scripts/buildenv_chiller.sh"

echo ""
echo "###################"
date -ud "@$SECONDS" "+Time taken to build Chiller environment: %H:%M:%S"
echo "###################"
echo "You can remove the conda cache with: 'docker volume rm $VOLUME'. It will be recreated at next run."
echo "###################"

exit 0
