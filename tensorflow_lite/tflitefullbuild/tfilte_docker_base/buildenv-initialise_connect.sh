#!/usr/bin/env bash

set -e

echo "### Initialising dep build..."
echo "### Please be patient, this can take 15-20 minutes..."

# Global Envs
export CONDAENV="tensorflow"
export PYTHONENV="3.7"
export CONDARC="/opt/conda/.condarc"

# Image Specific Envs
# Connect
export CONDAREQSCONNECT="/data/env_scripts/dependencies_connect.txt"
export ENVFILECONNECT="/data/environment_connect.yml"

exec docker run --rm -v "$(pwd)":/data -e CONDAENV -e PYTHONENV -e CONDARC -e CONDAREQSCONNECT -e ENVFILECONNECT 'condaforge/mambaforge-pypy3:4.13.0-1' /bin/bash -c "/data/env_scripts/buildenv_connect.sh"

exit 0
